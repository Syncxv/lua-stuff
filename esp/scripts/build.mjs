import fs from 'node:fs'
import * as path from 'node:path'
import { fileURLToPath } from 'url';
import crypto from 'node:crypto'
const __dirname = path.dirname(fileURLToPath(import.meta.url));
const main = async ()=> {
    const entryPoinnt = path.resolve(__dirname, '..', 'src', 'main.lua');

    const mainContent = requireFile(entryPoinnt)
    const cleanedMainContent = mainContent.replaceAll(/]]/g, ']] .. "]]" .. [[')

    //get hash of content
    const hash = crypto.createHash('sha256').update(mainContent).digest('hex');

    const final = `
    -- ${hash}

    syn.run_on_actor(getactors()[1], [[
        ${cleanedMainContent.replace("hashgnaghehehhehehehehe", `"${hash}"`)}
    ]]);
    
`

    console.log(final)
    if(!fs.existsSync('dist')) fs.mkdirSync('dist')
    fs.writeFileSync('dist/main.lua', final, {})
    fs.writeFileSync('dist/normal.lua', cleanedMainContent, {})

}

const requireRegex = /(?:local\s{1,10})?(?<varName>[\S\w]*)\s?=\s?require\(['"](?<modPath>.{1,10000})['"]\)/gm
function requireFile(pathBruh, visited=[]) {
    visited.push(pathBruh)
    let result = ""
    let contents = fs.readFileSync(pathBruh, 'utf-8')
    

    for (let line of contents.split('\n')) {
        if(line.startsWith("require")) {
            let fileName = line.match(/["'](.*)["']/)[1]
            if(!fileName) return result

            const modulePath = path.resolve(__dirname, '..', 'src', getFileName(fileName) );
            if(visited.includes(modulePath)) throw Error("bruh circular require eh")
            result += requireFile(modulePath, visited)
            continue
        } 
        
        const match = requireRegex.exec(line)
        if (match) {
            const fileName = match.groups.modPath
            const varName = match.groups.varName
            const modulePath = getPath(fileName)

            console.log(modulePath)

            if(visited.includes(modulePath)) throw Error("bruh circular require eh")
            console.log("require", fileName, varName)
            result += `${varName.includes(".") ? "" : "local "}${varName} = {}\n`;
            result += `do\n`;
            result += requireFile(modulePath, visited);
            result += `\n${varName} = ${fileName.split("/").at(-1)}_module\n`;
            result += `end\n`;
            continue
        }

        result += line + "\n"
        
    }
    return result
}

function getPath(fileName) {
    const poth = path.resolve(__dirname, '..', 'src', getFileName(fileName));
    const isFile = fs.existsSync(poth)

    return isFile ?  path.resolve(__dirname, '..', 'src', getFileName(fileName)) :  path.resolve(__dirname, '..', 'src', fileName, "main.lua");
}

function getFileName(fileName) {
    return fileName.endsWith(".lua") ? fileName : fileName + ".lua"
}

main().catch(err => console.error(err))
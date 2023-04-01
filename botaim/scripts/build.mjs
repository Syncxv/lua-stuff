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

}


function requireFile(pathBruh, visited=[]) {
    visited.push(pathBruh)
    let result = ""
    let contents = fs.readFileSync(pathBruh, 'utf-8')
    

    for (let line of contents.split('\n')) {
        if(line.startsWith("require")) {
            let fileName = line.match(/["'](.*)["']/)[1]
            if(!fileName) return result

            const modulePath = path.resolve(__dirname, '..', 'src', fileName.endsWith(".lua") ? fileName : fileName + ".lua");
            if(visited.includes(modulePath)) throw Error("bruh circular require eh")
            result += requireFile(modulePath, visited)

        } else {
            result += line + "\n"
        }
    }
    return result
}




main().catch(err => console.error(err))
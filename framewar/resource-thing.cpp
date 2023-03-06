__int64 __fastcall sub_140960420(__int64 a1) {
  char v1; // al
  int v3; // r8d
  unsigned int v4; // edx
  int v5; // ecx
  int v6; // eax
  int v7; // ecx
  __int64 v8; // rax
  _WORD * v9; // rax
  __int64 v10; // rax
  char v11; // bl
  __int64 v12; // rsi
  int v13; // r8d
  int v14; // ecx
  __int64 v15; // rcx
  unsigned __int64 v16; // rdx
  __int64 * v17; // rdx
  char v18; // al
  __int64 v19; // rax
  __int64 v20; // rax
  __int64 v21; // r8
  __int64 v22; // rax
  _WORD * v23; // rax
  unsigned __int128 v24; // rax
  unsigned __int64 v25; // r14
  __int64 v26; // r8
  __int64 v27; // rsi
  __int64 v28; // rdx
  int v29; // r8d
  int v30; // eax
  __int64 v31; // rbx
  unsigned int * v32; // rax
  __int64 v33; // rax
  __int64 v34; // rsi
  int v35; // edx
  __int64 v36; // rbx
  __int64 v37; // rax
  __int64 v38; // rsi
  int v39; // r8d
  int v40; // ecx
  unsigned __int128 v41; // rax
  __int64 v42; // rax
  __int64 v43; // rsi
  int v44; // edx
  __int64 v45; // rax
  __int64 v46; // rax
  __int64 v47; // r8
  __int64 v48; // rbx
  __int64 v49; // r14
  __int64 v50; // rdx
  int v51; // r8d
  int v52; // eax
  unsigned int * v53; // rax
  __int64 v54; // rsi
  int v55; // edx
  __int64 v56; // rbx
  __int64 v57; // r14
  __int64 v58; // rdx
  int v59; // r8d
  int v60; // eax
  unsigned int * v61; // rax
  __int64(__fastcall * * v62)(); // r12
  __int64 v63; // r14
  __int64 v64; // r13
  __int64 v65; // rsi
  __int64 v66; // rcx
  int v67; // r8d
  unsigned int * v68; // rax
  __int64 v69; // rcx
  __int64 * v70; // r9
  __int64 * v71; // rdx
  __int64 v72; // rcx
  __int64 * v73; // rbx
  __int64 * v74; // rsi
  __int64 v76; // rax
  char v77; // al
  __int64 v78; // rbx
  __int64 * v79; // rbx
  __int64(__fastcall * v80)(); // r8
  __int64 v81; // rax
  unsigned int v83; // [rsp+20h] [rbp-E0h] BYREF
  __int64(__fastcall * * v84)(); // [rsp+28h] [rbp-D8h] BYREF
  __int64 v85; // [rsp+30h] [rbp-D0h] BYREF
  __int64(__fastcall * v86)(); // [rsp+38h] [rbp-C8h] BYREF
  __int64(__fastcall * * v87)(); // [rsp+58h] [rbp-A8h] BYREF
  _QWORD v88[2]; // [rsp+60h] [rbp-A0h] BYREF
  char v89; // [rsp+77h] [rbp-89h]
  int v90; // [rsp+78h] [rbp-88h]
  __int64 v91; // [rsp+80h] [rbp-80h]
  char v92[192]; // [rsp+88h] [rbp-78h] BYREF
  __int64 v93[5]; // [rsp+148h] [rbp+48h] BYREF
  __int64 v94; // [rsp+170h] [rbp+70h]
  __int64 v95; // [rsp+178h] [rbp+78h]

  v1 = * (_BYTE * )(a1 + 33);
  if ((v1 & 7) != 0 || v1 == 32 || (v1 & 0xC) != 0) {
    *(_QWORD * ) & Seed =
      0x5851F42D4C957F2D i64 * * (_QWORD * ) & Seed + 0x14057B7EF767814F i64;
    v3 = __ROL4__( * (_DWORD * )(a1 + 1804), 1);
    v4 = ( * ( & Seed + 1) & 0x3FFFFFFF) % 0xFFFFFFFE + 1;
    v5 = ((a1 + 1804) >> 3) ^ 0x1129B414;
    v83 = v4;
    if ((v3 ^ (unsigned int)((a1 + 1804) >> 3) ^ 0x1129B414) != v4) {
      v6 = v5;
      v7 = __ROR4__(v4 ^ v5, 1);
      *(_DWORD * )(a1 + 1804) = v7;
      LODWORD(v84) = v3 ^ v6;
      *(_DWORD * )(a1 + 1800) = v7 ^ 0x992E7797;
      v8 = * (_QWORD * )(a1 + 1768) | 1 i64;
      *(_QWORD * )(a1 + 1768) = v8;
      v9 = (_WORD * )(v8 & 0xFFFFFFFFFFFFFFFE ui64);
      if (v9)
        *
        v9 |= 1 u;
      if ( * (_BYTE * )(a1 + 1808)) {
        v10 = * (_QWORD * )(a1 + 1776);
        if (v10) {
          if (( * (unsigned __int8(__fastcall ** )(__int64))(v10 + 8))(a1 +
              1776)) {
            v11 = byte_142D6AC50;
            byte_142D6AC50 = 1;
            ( * (void(__fastcall ** )(__int64, unsigned int * ,
              __int64(__fastcall ** * )()))( *
              (_QWORD * )(a1 + 1776) + 32 i64))(a1 + 1776, & v83, & v84);
            byte_142D6AC50 = v11;
          }
        }
      }
    }
  }
  if (byte_142DA1220) {
    v12 = sub_1400A6E10( & unk_142D68350, 5 i64);
    v13 = * (_DWORD * )(a1 + 24);
    v14 = * (_DWORD * )( * (_QWORD * )(a1 + 8) + 44 i64);
    LODWORD(v84) = * (_DWORD * )(a1 + 28);
    HIDWORD(v84) = v14;
    LODWORD(v85) = v13;
    sub_1400BBB00(v12 + 72, & v84);
    sub_1400A5E90(v12 + 72, (__int64)
      " running scripts [");
    sub_1400A71E0(v12, " running scripts [");
    v15 = qword_142CA0348;
    if (!qword_142CA0348) {
      sub_1401476F0( & qword_142CA0348);
      v15 = qword_142CA0348;
    }
    v16 = * (unsigned __int8 * )(a1 + 1761);
    if (v16 >= (unsigned __int64)(unsigned int) dword_142CA0350 >> 5)
      v17 = & qword_142D6C770;
    else
      v17 = (__int64 * )(v15 + 32 * v16);
    if ( * ((_BYTE * ) v17 + 31) == 0xFF)
      v17 = (__int64 * ) * v17;
    sub_1400A5E90(v12 + 72, (__int64) v17);
    sub_1400A5E90(v12 + 72, (__int64)
      ", net status=");
    sub_1400A71E0(v12, ", net status=");
    sub_1400A5990(v12 + 72, *(unsigned __int8 * )(a1 + 33));
    sub_1400A5E90(v12 + 72, (__int64)
      "], ephemeral: ");
    sub_1400A71E0(v12, "], ephemeral: ");
    sub_1400A5990(v12 + 72, ( * (_BYTE * )(a1 + 1762) & 0x10) != 0);
    sub_1400A5E90(v12 + 72, (__int64)
      "\n");
    sub_1400A71E0(v12, "\n");
  }
  if ( * (_WORD * )(a1 + 36)) {
    v18 = * (_BYTE * )(a1 + 1881);
    if (( * (_BYTE * )(a1 + 33) & 7) != 0) {
      if (v18)
        goto LABEL_64;
      v19 = sub_140792B80(a1);
      v20 = ( * (__int64(__fastcall ** )(__int64))( * (_QWORD * ) v19 + 800 i64))(v19);
      sub_1401C3010(v92, a1 + 16, v20, 0 i64, v83);
      LOBYTE(v21) = 1;
      sub_1400D7D30(a1, v92, v21);
      if ( * (_WORD * )(a1 + 36)) {
        if ( * (_BYTE * )(a1 + 1881) != 1) {
          v22 = * (_QWORD * )(a1 + 1872) | 1 i64;
          *(_BYTE * )(a1 + 1881) = 1;
          *(_QWORD * )(a1 + 1872) = v22;
          v23 = (_WORD * )(v22 & 0xFFFFFFFFFFFFFFFE ui64);
          if (v23)
            *
            v23 |= 1 u;
        }
        v24 = * (unsigned int * )(a1 + 1704) *
          (unsigned __int128) 0xE38E38E38E38E38F ui64;
        v89 = 31;
        v25 = 0 i64;
        LOBYTE(v87) = 0;
        v90 = 0;
        v91 = 0 i64;
        if ( * ((_QWORD * ) & v24 + 1) >> 6) {
          v26 = * (_QWORD * )(a1 + 1696);
          v27 = 0 i64;
          do {
            if ( ** (_QWORD ** ) sub_1402B2E10(v27 + v26 + 24)) {
              v28 = ** (_QWORD ** ) sub_1402B2E10(v27 + * (_QWORD * )(a1 + 1696) +
                24 i64);
              v29 = * (_DWORD * )(v28 + 24);
              v30 = * (_DWORD * )( * (_QWORD * )(v28 + 8) + 44 i64);
              LODWORD(v84) = * (_DWORD * )(v28 + 28);
              HIDWORD(v84) = v30;
              LODWORD(v85) = v29;
              v31 = sub_1400BBB00( & v87, & v84);
              sub_1400A5E90(v31, (__int64)
                ":");
              v32 = (unsigned int * ) sub_1402B2D80(
                v27 + * (_QWORD * )(a1 + 1696) + 24 i64, & v83);
              v33 = sub_1400BBBD0(v31, * v32);
              sub_1400A5E90(v33, (__int64)
                "\\n");
            }
            v26 = * (_QWORD * )(a1 + 1696);
            ++v25;
            v27 += 72 i64;
          } while (v25 < * (unsigned int * )(a1 + 1704) / 0x48 ui64);
        }
        v34 = sub_1400A6E10( & unk_142D68050, 3 i64);
        v35 = * (_DWORD * )(a1 + 28);
        HIDWORD(v84) = * (_DWORD * )( * (_QWORD * )(a1 + 8) + 44 i64);
        LODWORD(v85) = * (_DWORD * )(a1 + 24);
        LODWORD(v84) = v35;
        sub_1400BBB00(v34 + 72, & v84);
        sub_1400A5E90(v34 + 72, (__int64)
          " Broken resources detected for "
          "ScriptTrigger with scripts ");
        sub_1400A71E0(
          v34, " Broken resources detected for ScriptTrigger with scripts ");
        v36 = sub_1400A6DC0(v34, & v87);
        sub_1400A5E90(
          v36 + 72,
          (__int64)
          "Check the Instance() argument paths for your script!\n");
        sub_1400A71E0(v36,
          "Check the Instance() argument paths for your script!\n");
        sub_140792B80(a1);
        if (v89 == -1 && HIDWORD(v88[0]) != -1)
          sub_14009CE50(v87);
      }
      if (v94) {
        sub_14009CE50(v94);
        v94 = 0 i64;
        v95 = 0 i64;
      }
      if (v93[0])
        ( * (void(__fastcall ** )(__int64 * )) v93[0])(v93);
      goto LABEL_39;
    }
    if (!v18) {
      v37 = * (_QWORD * )(a1 + 496);
      if (v37 && !(unsigned __int8) sub_1405534A0( ** (_QWORD ** )(v37 + 184))) {
        v38 = sub_1400A6E10( & unk_142D68050, 4 i64);
        v39 = * (_DWORD * )(a1 + 24);
        v40 = * (_DWORD * )( * (_QWORD * )(a1 + 8) + 44 i64);
        LODWORD(v84) = * (_DWORD * )(a1 + 28);
        HIDWORD(v84) = v40;
        LODWORD(v85) = v39;
        sub_1400BBB00(v38 + 72, & v84);
        sub_1400A5E90(
          v38 + 72,
          (__int64)
          ": Client is attempting to run scripts with unresolved "
          "instances, deferring until instances are resolved\n");
        *(_QWORD * ) & v41 = sub_1400A71E0(
          v38, ": Client is attempting to run scripts with unresolved "
          "instances, deferring until instances are resolved\n");
        if (( * (_BYTE * )(a1 + 1762) & 0x20) != 0)
          return v41;
        if (dword_142DA1228 >
          *
          (_DWORD * )( * ((_QWORD * ) NtCurrentTeb() -> ThreadLocalStoragePointer +
              (unsigned int) TlsIndex) +
            2100 i64)) {
          Init_thread_header( & dword_142DA1228);
          if (dword_142DA1228 == -1) {
            v83 = 0;
            sub_1400BBA50( & unk_142DA1224, "/ReachedReplicationFence", & v83);
            Init_thread_footer( & dword_142DA1228);
          }
        }
        v42 = sub_140792540(a1);
        v87 = off_142517200;
        v88[0] = * (_QWORD * )(a1 + 16);
        ++ * (_DWORD * )(v88[0] + 8 i64);
        v88[1] = sub_14095FFE0;
        sub_1422D8E30(v42, & v87, & unk_142DA1224);
        *(_QWORD * ) & v41 = v87;
        if (v87) {
          if ( * v87 == sub_14095F110) {
            *(_QWORD * ) & v41 = sub_14095ED90(v88);
            *(_BYTE * )(a1 + 1762) |= 0x20 u;
            return v41;
          }
          *(_QWORD * ) & v41 =
            ((__int64(__fastcall * )(__int64(__fastcall ** * )())) * v87)( & v87);
        }
        *(_BYTE * )(a1 + 1762) |= 0x20 u;
        return v41;
      }
      v43 = sub_1400A6E10( & unk_142D68050, 4 i64);
      v44 = * (_DWORD * )(a1 + 28);
      HIDWORD(v84) = * (_DWORD * )( * (_QWORD * )(a1 + 8) + 44 i64);
      LODWORD(v85) = * (_DWORD * )(a1 + 24);
      LODWORD(v84) = v44;
      sub_1400BBB00(v43 + 72, & v84);
      sub_1400A5E90(
        v43 + 72,
        (__int64)
        ": Client has unresolved instances but we've reached "
        "replication fence, and host says there are no broke"
        "n instance. Check for server-only instances\n");
      sub_1400A71E0(
        v43, ": Client has unresolved instances but we've reached "
        "replication fence, and host says there are no broken instanc"
        "e. Check for server-only instances\n");
      v45 = sub_140792B80(a1);
      v46 = ( * (__int64(__fastcall ** )(__int64))( * (_QWORD * ) v45 + 800 i64))(v45);
      sub_1401C3010(v92, a1 + 16, v46, 0 i64, v83);
      LOBYTE(v47) = 1;
      sub_1400D7D30(a1, v92, v47);
      if ( * (_WORD * )(a1 + 36) && * (_DWORD * )(a1 + 1704) &&
        **
        (_QWORD ** ) sub_1402B2E10( * (_QWORD * )(a1 + 1696) + 24 i64)) {
        v48 = * (_QWORD * )(a1 + 1696);
        v49 = sub_1400A6E10( & unk_142D68050, 4 i64);
        sub_1400A5E90(v49 + 72, (__int64)
          "First script: ");
        sub_1400A71E0(v49, "First script: ");
        v50 = ** (_QWORD ** ) sub_1402B2E10(v48 + 24);
        v51 = * (_DWORD * )(v50 + 24);
        v52 = * (_DWORD * )( * (_QWORD * )(v50 + 8) + 44 i64);
        LODWORD(v84) = * (_DWORD * )(v50 + 28);
        HIDWORD(v84) = v52;
        LODWORD(v85) = v51;
        sub_1400BBB00(v49 + 72, & v84);
        sub_1400A5E90(v49 + 72, (__int64)
          ", function: ");
        sub_1400A71E0(v49, ", function: ");
        v53 = (unsigned int * ) sub_1402B2D80(v48 + 24, & v83);
        sub_1400BBBD0(v49 + 72, * v53);
        sub_1400A5E90(v49 + 72, (__int64)
          "\n");
        sub_1400A71E0(v49, "\n");
        sub_140792B80(a1);
      }
      if (v94) {
        sub_14009CE50(v94);
        v94 = 0 i64;
        v95 = 0 i64;
      }
      if (v93[0])
        ( * (void(__fastcall ** )(__int64 * )) v93[0])(v93);
      LABEL_39:
        sub_140122F00(v92);
      goto LABEL_64;
    }
    if (( * (_BYTE * )(a1 + 1762) & 0x40) == 0) {
      v54 = sub_1400A6E10( & unk_142D68050, 4 i64);
      v55 = * (_DWORD * )(a1 + 28);
      HIDWORD(v84) = * (_DWORD * )( * (_QWORD * )(a1 + 8) + 44 i64);
      LODWORD(v85) = * (_DWORD * )(a1 + 24);
      LODWORD(v84) = v55;
      sub_1400BBB00(v54 + 72, & v84);
      sub_1400A5E90(v54 + 72,
        (__int64)
        ": Client has unresolved instances, but also "
        "broken instances; running script anyway!\n");
      sub_1400A71E0(v54, ": Client has unresolved instances, but also broken "
        "instances; running script anyway!\n");
      if ( * (_DWORD * )(a1 + 1704) &&
        **
        (_QWORD ** ) sub_1402B2E10( * (_QWORD * )(a1 + 1696) + 24 i64)) {
        v56 = * (_QWORD * )(a1 + 1696);
        v57 = sub_1400A6E10( & unk_142D68050, 4 i64);
        sub_1400A5E90(v57 + 72, (__int64)
          "First script: ");
        sub_1400A71E0(v57, "First script: ");
        v58 = ** (_QWORD ** ) sub_1402B2E10(v56 + 24);
        v59 = * (_DWORD * )(v58 + 24);
        v60 = * (_DWORD * )( * (_QWORD * )(v58 + 8) + 44 i64);
        LODWORD(v84) = * (_DWORD * )(v58 + 28);
        HIDWORD(v84) = v60;
        LODWORD(v85) = v59;
        sub_1400BBB00(v57 + 72, & v84);
        sub_1400A5E90(v57 + 72, (__int64)
          ", function: ");
        sub_1400A71E0(v57, ", function: ");
        v61 = (unsigned int * ) sub_1402B2D80(v56 + 24, & v83);
        sub_1400BBBD0(v57 + 72, * v61);
        sub_1400A5E90(v57 + 72, (__int64)
          "\n");
        sub_1400A71E0(v57, "\n");
        sub_140792B80(a1);
      }
      *(_BYTE * )(a1 + 1762) |= 0x40 u;
    }
  }
  LABEL_64:
    if ( * (_DWORD * )(a1 + 1704))
      *
      (_BYTE * )(a1 + 1760) = 1;
  v41 = *
    (unsigned int * )(a1 + 1704) * (unsigned __int128) 0xE38E38E38E38E38F ui64;
  v62 = 0 i64;
  v84 = 0 i64;
  if ( * ((_QWORD * ) & v41 + 1) >> 6) {
    v63 = * (_QWORD * )(a1 + 1696);
    v64 = 0 i64;
    do {
      if (byte_142DA1220) {
        if ( ** (_QWORD ** ) sub_1402B2E10(v63 + v64 + 24)) {
          v65 = sub_1400A6E10( & unk_142D68350, 5 i64);
          v66 = ** (_QWORD ** ) sub_1402B2E10(v63 + v64 + 24);
          v67 = * (_DWORD * )(v66 + 24);
          HIDWORD(v87) = * (_DWORD * )( * (_QWORD * )(v66 + 8) + 44 i64);
          LODWORD(v87) = 0;
          LODWORD(v88[0]) = v67;
          sub_1400BBB00(v65 + 72, & v87);
          sub_1400A5E90(v65 + 72, (__int64)
            " - function: ");
          sub_1400A71E0(v65, " - function: ");
          v68 = (unsigned int * ) sub_1402B2D80(v63 + v64 + 24, & v83);
          sub_1400BBBD0(v65 + 72, * v68);
          sub_1400A5E90(v65 + 72, (__int64)
            "\n");
          sub_1400A71E0(v65, "\n");
        }
        v62 = v84;
      }
      v69 = ** (_QWORD ** )(v63 + v64);
      if (v69) {
        sub_140797F00(v69, v63 + v64 + 24);
      } else {
        if (( * (_BYTE * )(a1 + 1762) & 1) != 0 && ** (_QWORD ** )(a1 + 1416)) {
          v84 = 0 i64;
          v85 = 0 i64;
          sub_1407A3B20( & v84, 0 i64, 1 i64, a1 + 1416);
          v70 = (__int64 * )(a1 + 16);
          v71 = (__int64 * )((char * ) v84 + (unsigned int) v85);
          if (v71 >= (__int64 * )((char * ) v84 + HIDWORD(v85))) {
            sub_1407A3B20( & v84, v71, 1 i64, v70);
          } else {
            v72 = * v70;
            * v71 = * v70;
            ++ * (_DWORD * )(v72 + 8);
            LODWORD(v85) = (_DWORD) v71 - (_DWORD) v84 + 8;
          }
          sub_140798220( ** (_QWORD ** )(a1 + 1416), v63 + v64 + 24, & v84);
          v73 = (__int64 * ) v84;
          if (v84) {
            v74 = (__int64 * )((char * ) v84 + (unsigned int) v85);
            if (v84 != (__int64(__fastcall ** )()) v74) {
              do {
                if (( * (_DWORD * )( * v73 + 8)) -- == 1)
                  sub_1400B25C0();
                ++v73;
              } while (v73 != v74);
              v73 = (__int64 * ) v84;
            }
            if (v73 != (__int64 * ) & v86)
              sub_14009CE50(v73);
          }
          goto LABEL_103;
        }
        v76 = sub_14029AC60();
        if ((unsigned __int8) sub_14029EB30(v76, v63 + v64 + 24)) {
          v77 = * (_BYTE * )(a1 + 33);
          if ((v77 & 7) != 0 || (v77 & 0x11) == 0 && ! * (_BYTE * )(a1 + 1761)) {
            v78 = ** (_QWORD ** )(v63 + v64 + 64);
            v84 = off_1425171D0;
            v79 = (__int64 * )(v78 + 376);
            v85 = * (_QWORD * )(a1 + 16);
            ++ * (_DWORD * )(v85 + 8);
            v86 = sub_14095F890;
            if (v79 == (__int64 * ) & v84) {
              LABEL_98: if (v84) {
                if ( * v84 == sub_14095F100)
                  sub_14095ED90( & v85);
                else
                  ((void(__fastcall * )(__int64(__fastcall ** * )())) * v84)( & v84);
              }
            }
            else {
              if ( * v79) {
                ( * (void(__fastcall ** )(__int64 * )) * v79)(v79);
                * v79 = 0 i64;
              }
              if (v84) {
                v80 = v84[5];
                if (v80 == sub_14095EF90)
                  sub_14095EB90(v79, & v84);
                else
                  ((void(__fastcall * )(__int64(__fastcall ** * )(),
                    __int64 * )) v80)( & v84, v79);
                goto LABEL_98;
              }
            }
          }
          sub_1402B2E80(v63 + v64 + 24, a1);
          sub_1402B2E80(v63 + v64 + 24, ** (_QWORD ** )(a1 + 1416));
          v81 = sub_14029AC60();
          sub_140299C90(v81, ** (_QWORD ** )(v63 + v64 + 64));
        }
      }
      LABEL_103:
        v62 = (__int64(__fastcall ** )())((char * ) v62 + 1);
      v63 = * (_QWORD * )(a1 + 1696);
      v41 = * (unsigned int * )(a1 + 1704) *
        (unsigned __int128) 0xE38E38E38E38E38F ui64;
      v64 += 72 i64;
      v84 = v62;
    } while ((unsigned __int64) v62 < * ((_QWORD * ) & v41 + 1) > > 6);
  }
  return v41;
}
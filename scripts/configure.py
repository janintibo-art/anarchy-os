#!/usr/bin/env python3
import pathlib,sys
p=pathlib.Path(sys.argv[1]); root=pathlib.Path(sys.argv[2]).resolve()
s=p.read_text()
updates={
'BR2_ROOTFS_OVERLAY':str(root/'board/anarchy/overlay'),
'BR2_ROOTFS_POST_BUILD_SCRIPT':str(root/'scripts/post-build.sh'),
'BR2_TARGET_GENERIC_HOSTNAME':'anarchy-os',
'BR2_TARGET_GENERIC_ISSUE':'Anarchy OS experimental ARM64 / QEMU only',
}
for k,v in updates.items():
    import re
    s=re.sub(r'(?m)^'+k+r'=.*\n','',s)
    s=re.sub(r'(?m)^# '+k+r' is not set\n','',s)
    s+=f'{k}="{v}"\n'
p.write_text(s)

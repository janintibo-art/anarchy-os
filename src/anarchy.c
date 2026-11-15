#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/utsname.h>
#include <sys/sysinfo.h>
#include <unistd.h>
#include <dirent.h>

static void show_file(const char *path) {
    FILE *f=fopen(path,"r"); char line[256];
    if (!f) { printf("  indisponible: %s\n",path); return; }
    int n=0; while(fgets(line,sizeof line,f)&&n++<12) printf("  %s",line);
    fclose(f);
}
static void help(void){puts("Commandes: help, info, cpu, mem, net, sensors, mounts, exit");}
static void action(const char *s){
    struct utsname u; struct sysinfo m;
    if(!strcmp(s,"help")){help();}
    else if(!strcmp(s,"info")){if(!uname(&u))printf("Noyau: %s %s / %s\n",u.sysname,u.release,u.machine);puts("Profil: QEMU AArch64 (aucun pilote Samsung)");}
    else if(!strcmp(s,"cpu")){show_file("/proc/cpuinfo");}
    else if(!strcmp(s,"mem")){if(!sysinfo(&m))printf("RAM totale: %llu MiB / libre: %llu MiB\n",(unsigned long long)m.totalram*m.mem_unit/1048576,(unsigned long long)m.freeram*m.mem_unit/1048576);}
    else if(!strcmp(s,"mounts")){show_file("/proc/mounts");}
    else if(!strcmp(s,"net")){show_file("/proc/net/dev");}
    else if(!strcmp(s,"sensors")){
      DIR *d=opendir("/sys/class/thermal"); if(!d){puts("Capteurs indisponibles");return;} struct dirent *e; int found=0;
      while((e=readdir(d))){if(strncmp(e->d_name,"thermal_zone",12))continue; char p[256];snprintf(p,sizeof p,"/sys/class/thermal/%s/temp",e->d_name);printf("%s:\n",e->d_name);show_file(p);found++;}closedir(d);if(!found)puts("Aucun capteur thermique exposé");
    }
    else if(!strcmp(s,"exit")){puts("Fin de session.");}
    else puts("Commande inconnue. Tape help.");
}
int main(int argc,char**argv){
 puts("\n=================================\n ANARCHY OS v1 - LABORATOIRE ARM64\n=================================");
 if(argc>1){action(argv[1]);return 0;}
 help();char *line=NULL;size_t len=0;
 while(1){printf("anarchy> ");fflush(stdout);if(getline(&line,&len,stdin)<0)break;line[strcspn(line,"\r\n")]=0;if(!strcmp(line,"exit"))break;if(*line)action(line);}
 free(line);return 0;
}

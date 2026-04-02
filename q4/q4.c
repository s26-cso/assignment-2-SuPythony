#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    char op[6];
    int a, b;
    while (scanf("%s %d %d", op, &a, &b)!=EOF){
	char libname[20] = "./lib";
	strcat(libname, op);
	strcat(libname, ".so");
	void *lib = dlopen(libname, RTLD_NOW);
	int (*f)(int,int) = dlsym(lib, op);
	printf("%d\n", f(a,b));
	fflush(stdout);
	dlclose(lib);
    }
    return 0;
}

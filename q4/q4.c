#include <stdio.h>
#include <string.h>
#include <dlfcn.h>

int main() {
    while (1) {
	char op[6];
	int a, b;
	scanf("%s %d %d", op, &a, &b);
	char libname[12] = "lib";
	strcat(libname, op);
	strcat(libname, ".so");
	void *lib = dlopen(libname, RTLD_NOW);
	int (*f)(int,int) = dlsym(lib, op);
	printf("%d\n", f(a,b));
	dlclose(lib);	
    }
    return 0;
}

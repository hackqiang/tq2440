/*
 *	main.c: c function
 *	hackqiang
 */



static void delay()
{
	unsigned long i = 1000 * 1000 * 10;
	while(i--);
}


#define GPBCON (*(volatile unsigned long *)0x56000010)
#define GPBDAT (*(volatile unsigned long *)0x56000014)
#define GPBUP (*(volatile unsigned long *)0x56000018)
static void led(int x)
{
	GPBCON = 1<<(5*2) | 1<<(6*2) | 1<<(7*2) | 1<<(8*2) ;
	GPBUP = 0x7ff;
	GPBDAT = (~x & 0xf)<<5;
}


int main()
{
	int i = 0;
	while(1) {
		led(i%0x10);
		i++;
		delay();
	}
	return 0;
}

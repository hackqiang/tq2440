/*
 *	start.S: entry point
 *	modify from u-boot-1.1.6/cpu/arm920t/start.S
 *	hackqiang
 */

#include <config.h>



.globl _start
_start:
	b reset
	ldr	pc, _none 
	ldr	pc, _none	
	ldr	pc, _none
	ldr	pc, _none
	ldr	pc, _none
	ldr	pc, _none
	ldr	pc, _none
_none:	.word none

.balignl 16,0xdeadbeef

_TEXT_BASE:
	.word TEXT_BASE


/*
 * These are defined in the board-specific linker script.
 */
.globl _bss_start
_bss_start:
	.word __bss_start

.globl _bss_end
_bss_end:
	.word __bss_start



/*
 *	ok, les's go
 */
reset:
	/*
	 * set the cpu to SVC32 mode
	 */
	mrs	r0,cpsr
	bic	r0,r0,#0x1f
	orr	r0,r0,#0xd3
	msr	cpsr,r0

	/* init leds */
	RAW_LED_PORT_INIT_MACRO


	/* turn off the watchdog */
	ldr     r0, =pWTCON
	mov     r1, #0x0
	str     r1, [r0]

	/*
	 * mask all IRQs by setting all bits in the INTMR - default
	 */
	mov	r1, #0xffffffff
	ldr	r0, =INTMSK
	str	r1, [r0]
	ldr	r1, =0x7fff
	ldr	r0, =INTSUBMSK
	str	r1, [r0]


RAW_LED_MACRO 1

	/*
	 * flush v4 I/D caches
	 */
	mov	r0, #0
	mcr	p15, 0, r0, c7, c7, 0	/* flush v3/v4 cache */
	mcr	p15, 0, r0, c8, c7, 0	/* flush v4 TLB */

	/*
	 * disable MMU stuff and caches
	 */
	mrc	p15, 0, r0, c1, c0, 0
	bic	r0, r0, #0x00002300	@ clear bits 13, 9:8 (--V- --RS)
	bic	r0, r0, #0x00000087	@ clear bits 7, 2:0 (B--- -CAM)
	orr	r0, r0, #0x00000002	@ set bit 2 (A) Align
	orr	r0, r0, #0x00001000	@ set bit 12 (I) I-Cache
	mcr	p15, 0, r0, c1, c0, 0

#if 1
	/*
	 *	set SDRAM
	 */
	adr r0,1f
	ldr	r1, =BWSCON	/* Bus Width Status Controller */
	add r2, r0, #13*4
0:
	ldr r3, [r0], #4
	str r3, [r1], #4
	cmp r2, r0
	bne 0b
	b 2f
1:
    .long (0+(B1_BWSCON<<4)+(B2_BWSCON<<8)+(B3_BWSCON<<12)+(B4_BWSCON<<16)+(B5_BWSCON<<20)+(B6_BWSCON<<24)+(B7_BWSCON<<28))
    .long ((B0_Tacs<<13)+(B0_Tcos<<11)+(B0_Tacc<<8)+(B0_Tcoh<<6)+(B0_Tah<<4)+(B0_Tacp<<2)+(B0_PMC))   //GCS0
    .long ((B1_Tacs<<13)+(B1_Tcos<<11)+(B1_Tacc<<8)+(B1_Tcoh<<6)+(B1_Tah<<4)+(B1_Tacp<<2)+(B1_PMC))   //GCS1 
    .long ((B2_Tacs<<13)+(B2_Tcos<<11)+(B2_Tacc<<8)+(B2_Tcoh<<6)+(B2_Tah<<4)+(B2_Tacp<<2)+(B2_PMC))   //GCS2
    .long ((B3_Tacs<<13)+(B3_Tcos<<11)+(B3_Tacc<<8)+(B3_Tcoh<<6)+(B3_Tah<<4)+(B3_Tacp<<2)+(B3_PMC))   //GCS3
    .long ((B4_Tacs<<13)+(B4_Tcos<<11)+(B4_Tacc<<8)+(B4_Tcoh<<6)+(B4_Tah<<4)+(B4_Tacp<<2)+(B4_PMC))   //GCS4
    .long ((B5_Tacs<<13)+(B5_Tcos<<11)+(B5_Tacc<<8)+(B5_Tcoh<<6)+(B5_Tah<<4)+(B5_Tacp<<2)+(B5_PMC))   //GCS5
    .long ((B6_MT<<15)+(B6_Trcd<<2)+(B6_SCAN))    //GCS6
    .long ((B7_MT<<15)+(B7_Trcd<<2)+(B7_SCAN))    //GCS7 /* DM9000 width 16, wait enable */
    .long ((REFEN<<23)+(TREFMD<<22)+(Trp<<20)+(Trc<<18)+(Tchr<<16)+REFCNT)    
    .long 0x32                    // SCLK power saving mode, BANKSIZE 128M/128M
    .long 0x30                    // MRSR6 CL=3clk
    .long 0x30                    // MRSR7

#endif
RAW_LED_MACRO 2

2:
	/*
	 * set clock 
	 */
    ldr    r0,=LOCKTIME
    ldr    r1,=0xffffffff
    str    r1,[r0]

    ldr    r0,=CAMDIVN
    ldr    r1,=(0)
    str    r1,[r0]

    ldr     r0,=CLKDIVN     // Set ratios 1:2:4 for FCLK:HCLK:PCLK
    ldr     r1,=(3)
    str     r1,[r0]
	
	nop
	nop
	nop
	nop
	nop
	nop
	
    // Configure MPLL
    ldr    r0,=MPLLCON          
    ldr    r1,=((92<<12)+(1<<4)+1)
    str    r1,[r0]


RAW_LED_MACRO 3


	/*
	 * Set up the stack 
	 */
stack_setup:
	ldr	sp, _TEXT_BASE

	/* relocate U-Boot to RAM	    */
	adr	r0, _start		/* r0 <- current position of code   */
	ldr	r1, _TEXT_BASE		/* test if we run from flash or RAM */
	cmp r0, r1                  /* don't reloc during debug         */
	beq clear_bss

	ldr	r2, _start
	ldr	r3, _bss_start
	sub	r2, r3, r2		/* r2 <- size of _main            */
	add	r2, r0, r2		/* r2 <- source end address         */

RAW_LED_MACRO 4

copy_loop:
	ldmia	r0!, {r3-r10}		/* copy from source address [r0]    */
	stmia	r1!, {r3-r10}		/* copy to   target address [r1]    */
	cmp	r0, r2			/* until source end addreee [r2]    */
	ble	copy_loop

clear_bss:
	ldr	r0, _bss_start		/* find start of bss segment        */
	ldr	r1, _bss_end		/* stop here                        */
	mov r2, #0x0		/* clear     	*/


RAW_LED_MACRO 5

	ldr	pc, _main
_main:
	.word main


/*
 * exception handlers, now we don't care
 */
.align  5
none:
	nop

/*
 *	config.h: some reg info and config
 */


#define GPBCON    0x56000010  //Port B control
#define GPBDAT    0x56000014  //Port B data
#define GPBUP     0x56000018  //Pull-up control B

# define pWTCON		0x53000000
# define INTMOD		0X4A000004
# define INTMSK		0x4A000008	/* Interupt-Controller base addresses */
# define INTSUBMSK	0x4A00001C

// CLOCK & POWER MANAGEMENT
#define LOCKTIME   0x4c000000  //PLL lock time counter
#define MPLLCON    0x4c000004  //MPLL Control
#define UPLLCON    0x4c000008  //UPLL Control
#define CLKCON     0x4c00000c  //Clock generator control
#define CLKSLOW    0x4c000010  //Slow clock control
#define CLKDIVN    0x4c000014  //Clock divider control
#define CAMDIVN    0x4c000018


/* BWSCON */
#define DW8		 		(0x0)
#define DW16		 	(0x1)
#define DW32		 	(0x2)
#define WAIT		 	(0x1<<2)
#define UBLB		 	(0x1<<3)

#define B1_BWSCON	  	(DW16)
#define B2_BWSCON	  	(DW16)
#define B3_BWSCON	  	(DW16 + WAIT + UBLB)
#define B4_BWSCON	  	(DW16)
#define B5_BWSCON	  	(DW8)
#define B6_BWSCON	  	(DW32)
#define B7_BWSCON	  	(DW32)

// Memory control 
#define BWSCON    0x48000000  //Bus width & wait status
#define BANKCON0  0x48000004  //Boot ROM control
#define BANKCON1  0x48000008  //BANK1 control
#define BANKCON2  0x4800000c  //BANK2 cControl
#define BANKCON3  0x48000010  //BANK3 control
#define BANKCON4  0x48000014  //BANK4 control
#define BANKCON5  0x48000018  //BANK5 control
#define BANKCON6  0x4800001c  //BANK6 control
#define BANKCON7  0x48000020  //BANK7 control
#define REFRESH   0x48000024  //DRAM/SDRAM refresh
#define BANKSIZE  0x48000028  //Flexible Bank Size
#define MRSRB6    0x4800002c  //Mode register set for SDRAM
#define MRSRB7    0x48000030  //Mode register set for SDRAM


//BANK0CON 
#define B0_Tacs           0x0    //0clk
#define B0_Tcos           0x0    //0clk
#define B0_Tacc           0x7    //14clk
#define B0_Tcoh           0x0    //0clk
#define B0_Tah            0x0    //0clk
#define B0_Tacp           0x0    
#define B0_PMC            0x0    //normal

//BANK1CON
#define B1_Tacs           0x0    //0clk
#define B1_Tcos           0x0    //0clk
#define B1_Tacc           0x7    //14clk
#define B1_Tcoh           0x0    //0clk
#define B1_Tah            0x0    //0clk
#define B1_Tacp           0x0    
#define B1_PMC            0x0    //normal

//Bank 2 parameter
#define B2_Tacs           0x0    //0clk
#define B2_Tcos           0x0    //0clk
#define B2_Tacc           0x7    //14clk
#define B2_Tcoh           0x0    //0clk
#define B2_Tah            0x0    //0clk
#define B2_Tacp           0x0    
#define B2_PMC            0x0    //normal

//Bank 3 parameter
#define B3_Tacs           0x0    //0clk
#define B3_Tcos           0x0    //0clk
#define B3_Tacc           0x7    //14clk
#define B3_Tcoh           0x0    //0clk
#define B3_Tah            0x0    //0clk
#define B3_Tacp           0x0    
#define B3_PMC            0x0    //normal

//Bank 4 parameter
#define B4_Tacs           0x0    //0clk
#define B4_Tcos           0x0    //0clk
#define B4_Tacc           0x7    //14clk
#define B4_Tcoh           0x0    //0clk
#define B4_Tah            0x0    //0clk
#define B4_Tacp           0x0    
#define B4_PMC            0x0    //normal

//Bank 5 parameter
#define B5_Tacs           0x0    //0clk
#define B5_Tcos           0x0    //0clk
#define B5_Tacc           0x7    //14clk
#define B5_Tcoh           0x0    //0clk
#define B5_Tah            0x0    //0clk
#define B5_Tacp           0x0    
#define B5_PMC            0x0    //normal

//Bank 6 parameter
#define B6_MT             0x3    //SDRAM
//#define B6_Trcd           0x0    //2clk
#define B6_Trcd           0x1    //3clk
#define B6_SCAN           0x1    //9bit

//Bank 7 parameter
#define B7_MT             0x3    //SDRAM
//#define B7_Trcd           0x0    //2clk
#define B7_Trcd           0x1    //3clk
#define B7_SCAN           0x1    //9bit

//REFRESH parameter
#define REFEN             0x1    //Refresh enable
#define TREFMD            0x0    //CBR(CAS before RAS)/Auto refresh
#define Trp		 		0x0
#define Trc		    	0x3
#define Tchr		 	0x2
#define REFCNT		 	0x4f4









.macro RAW_LED_MACRO x
	ldr     r0,=GPBDAT
	ldr     r1,[r0]
	bic     r1,r1,#(0xf<<5)
	orr     r1,r1,#((0xf & ~(\x))<<5)
	str     r1, [r0]
.endm


// Configure GPF[4:7] as Output & pull-up turned off
.macro RAW_LED_PORT_INIT_MACRO
	ldr     r0,=GPBUP
	ldr     r1,[r0]
	orr     r1,r1,#((1<<7)|(1<<6)|(1<<5)|(1<<8))
	str     r1,[r0]

	RAW_LED_MACRO 0

	ldr     r0,=GPBCON
	ldr     r1,[r0]
	orr     r1,r1,#((1<<14)|(1<<12)|(1<<10)|(1<<16))
	str     r1,[r0]
.endm

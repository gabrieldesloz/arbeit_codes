
// bit manipulation
#define set_bit(Address,Bit)	((Address) |= (1 << Bit))
#define clr_bit(Address,Bit)	((Address) &= ~(1 << Bit))
#define tst_bit(Address,Bit)	(((Address) & (1 << Bit)))

#define FONTE_OFF	0
#define FONTE_50	50
#define FONTE_100	100

#define RLPS_MAX_VOLTAGE		160
#define RLPS_MIN_VOLTAGE		70
#define RLPS_MEAN_MAX_VOLTAGE	130
#define RLPS_MEAN_MIN_VOLTAGE	110

#define LCD_MAX_CHAR_LINE		20

#define F_CPU        8000000UL

#include <avr/io.h>
#include <util/delay.h>
#include "rl-test-firmware_pins.h"
#include "avrlib/avrlibtypes.h"
#include "avrlib/hc4067.h"

typedef struct struct_voltageData
{
	unsigned char mean;
	unsigned char min;
	unsigned char max;
}voltageData;

typedef struct struct_serialReceive
{
	unsigned char length;
	unsigned char serialData[30];
}serialReceive;



void initPorts(void);
void initVariables(void);
void initFunctions(void);
void doRLPSTest(void);

void testEEPROM(serialReceive *serialNumber);
void testPowerSupply(void);
void receiveSerialNumber(serialReceive *serialNumber, serialReceive *boardModel, serialReceive *boardRevision);
void writeSerialNumber(serialReceive *serialNumber, serialReceive *boardModel, serialReceive *boardRevision);
void verifySerialNumber(serialReceive *serialNumber, serialReceive *boardModel, serialReceive *boardRevision);
void testUSB(serialReceive *serialNumber);
void sendUSBStream(serialReceive *serialNumber);
void receiveUSBStream(serialReceive *serialData);
void testAlarmRelay(void);
unsigned char compareBuffer(unsigned char *buffer1, unsigned char *buffer2, unsigned char size);
void getVoltageData(voltageData *voltage);
void setPowerSupplyCharge(unsigned char percentage);
void doRLBPTest(void);
void testLCD(void);
void testLeds(void);
void testButtons(void);
void testEuros(void);
void testEuroRLPSOpen(void);
void testEuroRDIO1Open(void);
void testEuroRDIO2Open(void);
void testEuroRA81Open(void);
void testEuroRA82Open(void);
void testEuroRLPSLoop(void);
void testEuroRDIO1Loop(void);
void testEuroRDIO2Loop(void);
void testEuroRA81Loop(void);
void testEuroRA82Loop(void);
void waitForConnector(void);
void testRS232(void);
void testRS485(void);
void testIRIG(void);
void testEPCS(void);
void testEthernetLoopback();

extern void sendrs485asm(char);
extern char getrs485asm(void);
extern void initRS485(void);
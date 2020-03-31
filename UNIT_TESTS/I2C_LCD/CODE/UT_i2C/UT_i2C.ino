#include <LiquidCrystal_I2C.h>

//LiquidCrystal_I2C lcd(0x27,16,2);  //0x27 address got with a program
LiquidCrystal_I2C lcd(0x20,16,2); //for simulation
void setup()
{
lcd.init();// initialize the lcd

// Print a message to the LCD.
lcd.backlight();
lcd.print("Hello, world!");
}

void loop()
{
}

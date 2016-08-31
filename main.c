#include "stm32l152xe.h"



void delay(void)
{
  uint32_t del = 0x80000;
  
  while(del--);
}

int main(void)
{
  RCC->AHBENR |= RCC_AHBENR_GPIOAEN_Msk;
  GPIOA->MODER |= 1 << 10;
  GPIOA->ODR |= 1 << 5;
  /* Forever loop */
  for(;;)
  {
    GPIOA->ODR ^= 1 << 5;
    delay();
  } 
    
    
  return 0;
}

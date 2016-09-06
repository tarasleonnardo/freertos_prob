/* Standard includes. */
#include <stdio.h>

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

/* MCU includes */
#include "stm32l152xe.h"

/* The priorities assigned to the tasks. */
#define mainLED_TASK_PRIORITY			( tskIDLE_PRIORITY )

/* The LCD task uses printf() so requires more stack than most of the other
tasks. */
#define mainLED_TASK_STACK_SIZE			( configMINIMAL_STACK_SIZE )


volatile int32_t tmp_cnt = 0;

static void prvLEDTask( void *pvParameters );
static void delay(void);

/*-----------------------------------------------------------*/
int main( void )
{
	RCC->AHBENR |= RCC_AHBENR_GPIOAEN_Msk;
	GPIOA->MODER |= 1 << 10;
    GPIOA->ODR |= 1 << 5;

	if(xTaskCreate( prvLEDTask, "LED", mainLED_TASK_STACK_SIZE, NULL, mainLED_TASK_PRIORITY, NULL ))
	{
		vTaskStartScheduler();
	}

	for( ;; );
	return 0;
}
/*-----------------------------------------------------------*/
static void prvLEDTask( void *pvParameters )
{
	  /* Forever loop */
	  for(;;)
	  {
	    GPIOA->ODR ^= 1 << 5;
	    vTaskDelay(500);
	  }
}
/*-----------------------------------------------------------*/
static void delay(void)
{
  uint32_t del = 0x80000;

  while(del--);
}
/*-----------------------------------------------------------*/
uint32_t tmpi = 0;
void WWDG_IRQHandler1(void)
{
	tmpi++;
}

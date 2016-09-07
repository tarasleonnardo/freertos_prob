/* Standard includes. */
#include <stdio.h>

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
/* MCU includes */
#include "stm32l152xe.h"
#include "string.h"

/* The priorities assigned to the tasks. */
#define mainLED_TASK_PRIORITY			( tskIDLE_PRIORITY + 1)

/* The LCD task uses printf() so requires more stack than most of the other
tasks. */
#define mainLED_TASK_STACK_SIZE			( configMINIMAL_STACK_SIZE )


volatile int32_t tmp_cnt = 0;
QueueHandle_t queue = 0;

static void prvBTNTask( void *pvParameters );
static void prvLEDTask( void *pvParameters );
static void delay(void);

/*-----------------------------------------------------------*/
int main( void )
{
	uint8_t arr = 1;
	uint8_t arr1 = 0;

	memcpy(&arr1, &arr, sizeof(arr1));

	RCC->AHBENR |= RCC_AHBENR_GPIOAEN_Msk;
	GPIOA->MODER |= 1 << 10;
    GPIOA->ODR |= 1 << 5;


    if(0 == (queue = xQueueCreate(40, sizeof(uint32_t))))
    {
    	for(;;);
    }

	if(pdPASS == xTaskCreate( prvLEDTask, "LED", mainLED_TASK_STACK_SIZE, NULL, mainLED_TASK_PRIORITY, NULL ) &&
	   pdPASS == xTaskCreate( prvBTNTask, "BTN", mainLED_TASK_STACK_SIZE, NULL, mainLED_TASK_PRIORITY, NULL ))
	{
		vTaskStartScheduler();
	}

	for( ;; );
	return 0;
}

/*-----------------------------------------------------------*/
static void prvBTNTask( void *pvParameters )
{
	uint32_t item = 1;

	RCC->AHBENR |= RCC_AHBENR_GPIOCEN_Msk;

	  for(;;)
	  {
		if((GPIOC->IDR & (1 << 13)) == 0)
		{
			xQueueSend(queue, (void *)&item, 0);
			if(++item > 5)
			{
				item = 1;
			}

			vTaskDelay(200);
		}
		vTaskDelay(50);
	  }
}

/*-----------------------------------------------------------*/
static void prvLEDTask( void *pvParameters )
{
	uint32_t buf = 0;

	  /* Forever loop */
	  for(;;)
	  {
		  if(pdTRUE == xQueueReceive(queue, &buf, 0))
		  {
			  while(buf--)
			  {
				  GPIOA->ODR |= 1 << 5;
				  vTaskDelay(300);
				  GPIOA->ODR &= ~(1 << 5);
				  vTaskDelay(700);
			  }
		  }else
		  {
			  vTaskDelay(50);
		  }
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

/* Standard includes. */
#include <stdio.h>

/* Kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"

/* The priorities assigned to the tasks. */
#define mainLED_TASK_PRIORITY			( tskIDLE_PRIORITY + 1 )

/* The LCD task uses printf() so requires more stack than most of the other
tasks. */
#define mainLED_TASK_STACK_SIZE			( configMINIMAL_STACK_SIZE * 2 )

static void prvLEDTask( void *pvParameters );

void main( void )
{
	xTaskCreate( prvLEDTask, "LCD", mainLED_TASK_STACK_SIZE, NULL, mainLED_TASK_PRIORITY, NULL );

	vTaskStartScheduler();

	for( ;; );
}
/*-----------------------------------------------------------*/

static void prvLEDTask( void *pvParameters )
{
	for(;;);
}

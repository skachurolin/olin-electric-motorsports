#include "libs/gpio/api.h"
#include "libs/gpio/pin_defs.h"

gpio_t DASHBOARD_POWER = PB0;
gpio_t SERVICE_SECTION_POWER = PB1;
gpio_t THROTTLE_POWER = PB2;

void power_device(gpio_t power_device);

void power_all(void);

void power_off_device(gpio_t power_device);

void power_off_all(void);
#include "libs/gpio/api.h"
#include "libs/gpio/pin_defs.h"

gpio_t DASHBOARD_POWER = PB0;
gpio_t SERVICE_SECTION_POWER = PB1;
gpio_t THROTTLE_POWER = PB2;

void power_device(gpio_t power_device) {
    gpio_set_pin(power_device);
}

void power_all(void) {
    gpio_set_pin(DASHBOARD_POWER);
    gpio_set_pin(SERVICE_SECTION_POWER);
    gpio_set_pin(THROTTLE_POWER);
}

void power_off_device(gpio_t power_device) {
    gpio_clear_pin(power_device);
}

void power_off_all(void) {
    gpio_clear_pin(DASHBOARD_POWER);
    gpio_clear_pin(SERVICE_SECTION_POWER);
    gpio_clear_pin(THROTTLE_POWER);
}
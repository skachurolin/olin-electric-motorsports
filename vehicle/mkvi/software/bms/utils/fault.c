#include "fault.h"

#include "vehicle/mkv/software/bms/utils/fault.h"
#include "vehicle/mkvi/software/bms/can_api.h"
#include "vehicle/mkvi/software/bms/bms_config.h"

#include "libs/gpio/api.h"

void set_fault(enum bms_fault_e the_fault) {
    gpio_clear_pin(BMS_RELAY_LSD);

    if (bms_core.bms_fault == BMS_FAULT_NONE) {
        bms_core.bms_fault = the_fault;
    }
}

#include "sample.h"
#include "functions.h"	
#include "include_globals.h"

uint32_t s_to_mr(uint32_t seconds, uint32_t timer_freq, uint32_t prescaler);
uint32_t hz_to_mr(uint32_t hz, uint32_t timer_freq, uint32_t prescaler);
uint32_t ms_to_mr(uint32_t ms, uint32_t timer_freq, uint32_t prescaler);

uint8_t exor_4_bytes(uint32_t v);
uint8_t or_4_bytes(uint32_t v);
uint8_t and_4_bytes(uint32_t v);

uint8_t not(uint8_t v);

void init();
void blink_leds_value(uint8_t v);
void blink_all_leds();
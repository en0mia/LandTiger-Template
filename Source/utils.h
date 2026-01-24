#include "sample.h"
#include "functions.h"	

uint32_t s_to_mr(uint32_t seconds, uint32_t timer_freq, uint32_t prescaler);
uint32_t hz_to_mr(uint32_t hz, uint32_t timer_freq, uint32_t prescaler);
uint32_t ms_to_mr(uint32_t ms, uint32_t timer_freq, uint32_t prescaler);
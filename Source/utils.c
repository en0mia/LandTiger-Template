#include "utils.h"

//	here you can add the functions that use during the simulation or the exam

// === TIMERS ===
uint32_t s_to_mr(uint32_t seconds, uint32_t timer_freq, uint32_t prescaler) {
    return (seconds * timer_freq) / (prescaler + 1);
}

uint32_t ms_to_mr(uint32_t ms, uint32_t timer_freq, uint32_t prescaler) {
    return ((ms / 1000) * timer_freq) / (prescaler + 1);
}

uint32_t hz_to_mr(uint32_t hz, uint32_t timer_freq, uint32_t prescaler) {
    return timer_freq / ((prescaler + 1) * hz);
}
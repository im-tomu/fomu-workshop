#ifndef _RGB_H_
#define _RGB_H_

void rgb_init(void);
void rgb_set(uint8_t r, uint8_t g, uint8_t b);

// The amount of time to stay off or on
void rgb_on_time(uint8_t ms);
void rgb_off_time(uint8_t ms);

// The amount of time to breathe in/out
void rgb_in_time(uint8_t ms);
void rgb_out_time(uint8_t ms);

#endif /* _RGB_H_ */
#ifndef __REBOOT_H_
#define __REBOOT_H_

#include <generated/csr.h>

__attribute__((noreturn)) static inline void reboot(void) {
	        reboot_ctrl_write(0xac);
		        while (1);
}

__attribute__((noreturn)) static inline void reboot_to_image(uint8_t image_index) {
	        reboot_ctrl_write(0xac | (image_index & 3) << 0);
		        while (1);
}

#endif /* __REBOOT_H_ */

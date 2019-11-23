#ifndef __USB_EPTRI_H_
#define __USB_EPTRI_H_

#ifdef CSR_ACCESSORS_DEFINED
extern void csr_writeb(uint8_t value, unsigned long addr);
extern uint8_t csr_readb(unsigned long addr);
extern void csr_writew(uint16_t value, unsigned long addr);
extern uint16_t csr_readw(unsigned long addr);
extern void csr_writel(uint32_t value, unsigned long addr);
extern uint32_t csr_readl(unsigned long addr);
#else /* ! CSR_ACCESSORS_DEFINED */
#include <hw/common.h>
#endif /* ! CSR_ACCESSORS_DEFINED */

#define CSR_USB_BASE 0xe0004800L
#define CSR_USB_PULLUP_OUT_ADDR 0xe0004800L
#define CSR_USB_PULLUP_OUT_SIZE 1
static inline unsigned char usb_pullup_out_read(void) {
	unsigned char r = csr_readl(0xe0004800L);
	return r;
}
static inline void usb_pullup_out_write(unsigned char value) {
	csr_writel(value, 0xe0004800L);
}
#define CSR_USB_ADDRESS_ADDR 0xe0004804L
#define CSR_USB_ADDRESS_SIZE 1
static inline unsigned char usb_address_read(void) {
	unsigned char r = csr_readl(0xe0004804L);
	return r;
}
static inline void usb_address_write(unsigned char value) {
	csr_writel(value, 0xe0004804L);
}
#define CSR_USB_ADDRESS_ADDR_OFFSET 0
#define CSR_USB_ADDRESS_ADDR_SIZE 7
#define CSR_USB_NEXT_EV_ADDR 0xe0004808L
#define CSR_USB_NEXT_EV_SIZE 1
static inline unsigned char usb_next_ev_read(void) {
	unsigned char r = csr_readl(0xe0004808L);
	return r;
}
#define CSR_USB_NEXT_EV_IN_OFFSET 0
#define CSR_USB_NEXT_EV_IN_SIZE 1
#define CSR_USB_NEXT_EV_OUT_OFFSET 1
#define CSR_USB_NEXT_EV_OUT_SIZE 1
#define CSR_USB_NEXT_EV_SETUP_OFFSET 2
#define CSR_USB_NEXT_EV_SETUP_SIZE 1
#define CSR_USB_NEXT_EV_RESET_OFFSET 3
#define CSR_USB_NEXT_EV_RESET_SIZE 1
#define CSR_USB_SETUP_DATA_ADDR 0xe000480cL
#define CSR_USB_SETUP_DATA_SIZE 1
static inline unsigned char usb_setup_data_read(void) {
	unsigned char r = csr_readl(0xe000480cL);
	return r;
}
#define CSR_USB_SETUP_DATA_DATA_OFFSET 0
#define CSR_USB_SETUP_DATA_DATA_SIZE 8
#define CSR_USB_SETUP_CTRL_ADDR 0xe0004810L
#define CSR_USB_SETUP_CTRL_SIZE 1
static inline unsigned char usb_setup_ctrl_read(void) {
	unsigned char r = csr_readl(0xe0004810L);
	return r;
}
static inline void usb_setup_ctrl_write(unsigned char value) {
	csr_writel(value, 0xe0004810L);
}
#define CSR_USB_SETUP_CTRL_RESET_OFFSET 5
#define CSR_USB_SETUP_CTRL_RESET_SIZE 1
#define CSR_USB_SETUP_STATUS_ADDR 0xe0004814L
#define CSR_USB_SETUP_STATUS_SIZE 1
static inline unsigned char usb_setup_status_read(void) {
	unsigned char r = csr_readl(0xe0004814L);
	return r;
}
#define CSR_USB_SETUP_STATUS_EPNO_OFFSET 0
#define CSR_USB_SETUP_STATUS_EPNO_SIZE 4
#define CSR_USB_SETUP_STATUS_HAVE_OFFSET 4
#define CSR_USB_SETUP_STATUS_HAVE_SIZE 1
#define CSR_USB_SETUP_STATUS_PEND_OFFSET 5
#define CSR_USB_SETUP_STATUS_PEND_SIZE 1
#define CSR_USB_SETUP_STATUS_IS_IN_OFFSET 6
#define CSR_USB_SETUP_STATUS_IS_IN_SIZE 1
#define CSR_USB_SETUP_STATUS_DATA_OFFSET 7
#define CSR_USB_SETUP_STATUS_DATA_SIZE 1
#define CSR_USB_SETUP_EV_STATUS_ADDR 0xe0004818L
#define CSR_USB_SETUP_EV_STATUS_SIZE 1
static inline unsigned char usb_setup_ev_status_read(void) {
	unsigned char r = csr_readl(0xe0004818L);
	return r;
}
static inline void usb_setup_ev_status_write(unsigned char value) {
	csr_writel(value, 0xe0004818L);
}
#define CSR_USB_SETUP_EV_PENDING_ADDR 0xe000481cL
#define CSR_USB_SETUP_EV_PENDING_SIZE 1
static inline unsigned char usb_setup_ev_pending_read(void) {
	unsigned char r = csr_readl(0xe000481cL);
	return r;
}
static inline void usb_setup_ev_pending_write(unsigned char value) {
	csr_writel(value, 0xe000481cL);
}
#define CSR_USB_SETUP_EV_ENABLE_ADDR 0xe0004820L
#define CSR_USB_SETUP_EV_ENABLE_SIZE 1
static inline unsigned char usb_setup_ev_enable_read(void) {
	unsigned char r = csr_readl(0xe0004820L);
	return r;
}
static inline void usb_setup_ev_enable_write(unsigned char value) {
	csr_writel(value, 0xe0004820L);
}
#define CSR_USB_IN_DATA_ADDR 0xe0004824L
#define CSR_USB_IN_DATA_SIZE 1
static inline unsigned char usb_in_data_read(void) {
	unsigned char r = csr_readl(0xe0004824L);
	return r;
}
static inline void usb_in_data_write(unsigned char value) {
	csr_writel(value, 0xe0004824L);
}
#define CSR_USB_IN_DATA_DATA_OFFSET 0
#define CSR_USB_IN_DATA_DATA_SIZE 8
#define CSR_USB_IN_CTRL_ADDR 0xe0004828L
#define CSR_USB_IN_CTRL_SIZE 1
static inline unsigned char usb_in_ctrl_read(void) {
	unsigned char r = csr_readl(0xe0004828L);
	return r;
}
static inline void usb_in_ctrl_write(unsigned char value) {
	csr_writel(value, 0xe0004828L);
}
#define CSR_USB_IN_CTRL_EPNO_OFFSET 0
#define CSR_USB_IN_CTRL_EPNO_SIZE 4
#define CSR_USB_IN_CTRL_RESET_OFFSET 5
#define CSR_USB_IN_CTRL_RESET_SIZE 1
#define CSR_USB_IN_CTRL_STALL_OFFSET 6
#define CSR_USB_IN_CTRL_STALL_SIZE 1
#define CSR_USB_IN_STATUS_ADDR 0xe000482cL
#define CSR_USB_IN_STATUS_SIZE 1
static inline unsigned char usb_in_status_read(void) {
	unsigned char r = csr_readl(0xe000482cL);
	return r;
}
#define CSR_USB_IN_STATUS_IDLE_OFFSET 0
#define CSR_USB_IN_STATUS_IDLE_SIZE 1
#define CSR_USB_IN_STATUS_HAVE_OFFSET 4
#define CSR_USB_IN_STATUS_HAVE_SIZE 1
#define CSR_USB_IN_STATUS_PEND_OFFSET 5
#define CSR_USB_IN_STATUS_PEND_SIZE 1
#define CSR_USB_IN_EV_STATUS_ADDR 0xe0004830L
#define CSR_USB_IN_EV_STATUS_SIZE 1
static inline unsigned char usb_in_ev_status_read(void) {
	unsigned char r = csr_readl(0xe0004830L);
	return r;
}
static inline void usb_in_ev_status_write(unsigned char value) {
	csr_writel(value, 0xe0004830L);
}
#define CSR_USB_IN_EV_PENDING_ADDR 0xe0004834L
#define CSR_USB_IN_EV_PENDING_SIZE 1
static inline unsigned char usb_in_ev_pending_read(void) {
	unsigned char r = csr_readl(0xe0004834L);
	return r;
}
static inline void usb_in_ev_pending_write(unsigned char value) {
	csr_writel(value, 0xe0004834L);
}
#define CSR_USB_IN_EV_ENABLE_ADDR 0xe0004838L
#define CSR_USB_IN_EV_ENABLE_SIZE 1
static inline unsigned char usb_in_ev_enable_read(void) {
	unsigned char r = csr_readl(0xe0004838L);
	return r;
}
static inline void usb_in_ev_enable_write(unsigned char value) {
	csr_writel(value, 0xe0004838L);
}
#define CSR_USB_OUT_DATA_ADDR 0xe000483cL
#define CSR_USB_OUT_DATA_SIZE 1
static inline unsigned char usb_out_data_read(void) {
	unsigned char r = csr_readl(0xe000483cL);
	return r;
}
#define CSR_USB_OUT_DATA_DATA_OFFSET 0
#define CSR_USB_OUT_DATA_DATA_SIZE 8
#define CSR_USB_OUT_CTRL_ADDR 0xe0004840L
#define CSR_USB_OUT_CTRL_SIZE 1
static inline unsigned char usb_out_ctrl_read(void) {
	unsigned char r = csr_readl(0xe0004840L);
	return r;
}
static inline void usb_out_ctrl_write(unsigned char value) {
	csr_writel(value, 0xe0004840L);
}
#define CSR_USB_OUT_CTRL_EPNO_OFFSET 0
#define CSR_USB_OUT_CTRL_EPNO_SIZE 4
#define CSR_USB_OUT_CTRL_ENABLE_OFFSET 4
#define CSR_USB_OUT_CTRL_ENABLE_SIZE 1
#define CSR_USB_OUT_CTRL_RESET_OFFSET 5
#define CSR_USB_OUT_CTRL_RESET_SIZE 1
#define CSR_USB_OUT_CTRL_STALL_OFFSET 6
#define CSR_USB_OUT_CTRL_STALL_SIZE 1
#define CSR_USB_OUT_STATUS_ADDR 0xe0004844L
#define CSR_USB_OUT_STATUS_SIZE 1
static inline unsigned char usb_out_status_read(void) {
	unsigned char r = csr_readl(0xe0004844L);
	return r;
}
#define CSR_USB_OUT_STATUS_EPNO_OFFSET 0
#define CSR_USB_OUT_STATUS_EPNO_SIZE 4
#define CSR_USB_OUT_STATUS_HAVE_OFFSET 4
#define CSR_USB_OUT_STATUS_HAVE_SIZE 1
#define CSR_USB_OUT_STATUS_PEND_OFFSET 5
#define CSR_USB_OUT_STATUS_PEND_SIZE 1
#define CSR_USB_OUT_EV_STATUS_ADDR 0xe0004848L
#define CSR_USB_OUT_EV_STATUS_SIZE 1
static inline unsigned char usb_out_ev_status_read(void) {
	unsigned char r = csr_readl(0xe0004848L);
	return r;
}
static inline void usb_out_ev_status_write(unsigned char value) {
	csr_writel(value, 0xe0004848L);
}
#define CSR_USB_OUT_EV_PENDING_ADDR 0xe000484cL
#define CSR_USB_OUT_EV_PENDING_SIZE 1
static inline unsigned char usb_out_ev_pending_read(void) {
	unsigned char r = csr_readl(0xe000484cL);
	return r;
}
static inline void usb_out_ev_pending_write(unsigned char value) {
	csr_writel(value, 0xe000484cL);
}
#define CSR_USB_OUT_EV_ENABLE_ADDR 0xe0004850L
#define CSR_USB_OUT_EV_ENABLE_SIZE 1
static inline unsigned char usb_out_ev_enable_read(void) {
	unsigned char r = csr_readl(0xe0004850L);
	return r;
}
static inline void usb_out_ev_enable_write(unsigned char value) {
	csr_writel(value, 0xe0004850L);
}

#define USB_INTERRUPT 3

#endif /* __USB_EPTRI_H_ */

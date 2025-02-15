/*********************************************************************
 *
 *                Microchip USB C18 Firmware Version 1.0
 *
 * This file is generated by Microchip USB Wizard Version 1.0, 2004
 *********************************************************************
 * FileName:        usbdsc.c
 * Dependencies:    See INCLUDES section below
 * Processor:       PIC18
 * Compiler:        C18 3.00
 * Company:         Microchip Technology, Inc.
 *
 * Software License Agreement
 *
 * The software supplied herewith by Microchip Technology Incorporated
 * (the �Company�) for its PICmicro� Microcontroller is intended and
 * supplied to you, the Company�s customer, for use solely and
 * exclusively on Microchip PICmicro Microcontroller products. The
 * software is owned by the Company and/or its supplier, and is
 * protected under applicable copyright laws. All rights are reserved.
 * Any use in violation of the foregoing restrictions may subject the
 * user to criminal sanctions under applicable laws, as well as to
 * civil liability for the breach of the terms and conditions of this
 * license.
 *
 * THIS SOFTWARE IS PROVIDED IN AN �AS IS� CONDITION. NO WARRANTIES,
 * WHETHER EXPRESS, IMPLIED OR STATUTORY, INCLUDING, BUT NOT LIMITED
 * TO, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 * PARTICULAR PURPOSE APPLY TO THIS SOFTWARE. THE COMPANY SHALL NOT,
 * IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL OR
 * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
 *
 ********************************************************************/

/*********************************************************************
 * Descriptor specific type definitions are defined in:
 * system\usb\usbdefs\usbdefs_std_dsc.h
 *
 * Configuration information is defined in:
 * autofiles\usbcfg.h
 ********************************************************************/
 
/** I N C L U D E S *************************************************/
#include "system\typedefs.h"
#include "system\usb\usb.h"

/** C O N S T A N T S ************************************************/
#pragma romdata

/* Device Descriptor */
rom USB_DEV_DSC device_dsc=
{    
    sizeof(USB_DEV_DSC),    // Size of this descriptor in bytes
    DSC_DEV,                // DEVICE descriptor type
    0x0200,                 // USB Spec Release Number in BCD format
    0x00,                   // Class Code
    0x00,                   // Subclass code
    0x00,                   // Protocol code
    EP0_BUFF_SIZE,          // Max packet size for EP0, see usbcfg.h
    0x04D8,                 // Vendor ID = 1240
    0x0033,                 // Product ID = 51
    0x0001,                 // Device release number in BCD format
    0x01,                   // Manufacturer string index
    0x02,                   // Product string index
    0x03,                   // Device serial number string index
    0x02                    // Number of possible configurations
};

/* Configuration 1 Descriptor */
CFG01={
    /* Configuration Descriptor */
    sizeof(USB_CFG_DSC),    // Size of this descriptor in bytes
    DSC_CFG,                // CONFIGURATION descriptor type
    sizeof(cfg01),          // Total length of data for this cfg
    1,                      // Number of interfaces in this cfg
    1,                      // Index value of this configuration
    2,                      // Configuration string index
    _DEFAULT,               // Attributes, see usbdefs_std_dsc.h
    50,                     // Max power consumption (2X mA)

    /* Interface Descriptor */
    sizeof(USB_INTF_DSC),   // Size of this descriptor in bytes
    DSC_INTF,               // INTERFACE descriptor type
    0,                      // Interface Number
    0,                      // Alternate Setting Number
    2,                      // Number of endpoints in this intf
    HID_INTF,               // Class code
    0,                      // Subclass code
    0,                      // Protocol code
    0,                      // Interface string index

    /* HID Class-Specific Descriptor */
    sizeof(USB_HID_DSC),    // Size of this descriptor in bytes
    DSC_HID,                // HID descriptor type
    0x0001,                 // HID Spec Release Number in BCD format
    0x00,                   // Country Code (0x00 for Not supported)
    1,                      // Number of class descriptors, see usbcfg.h
    DSC_RPT,                // Report descriptor type
    sizeof(hid_rpt01),      // Size of the report descriptor

    /* Endpoint Descriptor 1 in */
    sizeof(USB_EP_DSC),
    DSC_EP,
    _EP01_IN,
    _BULK,
    HID_INT_IN_EP_SIZE,
    0x01,

    /* Endpoint Descriptor 1 out */
    sizeof(USB_EP_DSC),
    DSC_EP,
    _EP01_OUT,
    _BULK,
    HID_INT_OUT_EP_SIZE,
    0x01
};

/* Configuration 2 Descriptor */
CFG02={
    /* Configuration Descriptor */
    sizeof(USB_CFG_DSC),    // Size of this descriptor in bytes
    DSC_CFG,                // CONFIGURATION descriptor type
    sizeof(cfg02),          // Total length of data for this cfg
    1,                      // Number of interfaces in this cfg
    2,                      // Index value of this configuration
    4,                      // Configuration string index
    _DEFAULT,               // Attributes, see usbdefs_std_dsc.h
    50,                     // Max power consumption (2X mA)

    /* Interface Descriptor */
    sizeof(USB_INTF_DSC),   // Size of this descriptor in bytes
    DSC_INTF,               // INTERFACE descriptor type
    0,                      // Interface Number
    0,                      // Alternate Setting Number
    2,                      // Number of endpoints in this intf
    0xFF,                   // Class code (vendor defined)
    0,                      // Subclass code
    0,                      // Protocol code
    0,                      // Interface string index

    /* Endpoint Descriptor 1 in */
    sizeof(USB_EP_DSC),
    DSC_EP,
    _EP01_IN,
    _BULK,
    HID_INT_IN_EP_SIZE,
    0x01,

    /* Endpoint Descriptor 1 out */
    sizeof(USB_EP_DSC),
    DSC_EP,
    _EP01_OUT,
    _BULK,
    HID_INT_OUT_EP_SIZE,
    0x01
};

rom struct{byte bLength;byte bDscType;word string[1];}sd000={
sizeof(sd000),DSC_STR,0x0409};

rom struct{byte bLength;byte bDscType;word string[25];}sd001={
sizeof(sd001),DSC_STR,
'M','i','c','r','o','c','h','i','p',' ','T','e','c','h','n','o','l','o','g','y',' ','I','n','c','.'};

rom struct{byte bLength;byte bDscType;word string[35];}sd002={
sizeof(sd002),DSC_STR,
'P','I','C','k','i','t',' ','2',' ','M','i','c','r','o','c','o','n','t','r','o','l','l','e','r',' ','P','r','o','g','r','a','m','m','e','r'};

rom struct{byte bLength;byte bDscType;word string[10];}sd003={
sizeof(sd003),DSC_STR,
'P','I','C','1','8','F','2','5','5','0'};

rom struct{byte bLength;byte bDscType;word string[24];}sd004={
sizeof(sd004),DSC_STR,
'P','I','C','k','i','t',' ','2',' ','C','o','n','f','i','g','u','r','a','t','i','o','n',' ','2'};

rom struct{byte report[29];}hid_rpt01={
    0x06, 0x00, 0xFF,       // Usage Page (Vendor Defined)
    0x09, 0x01,             // Usage (Vendor Usage)
    0xA1, 0x01,             // Collection (Application)
    0x19, 0x01,             //      Usage Minimum (Vendor Usage = 1)
//    0x29, 0x08,             //      Usage Maximum (Vendor Usage = 8)
    0x29, 0x40,             //      Usage Maximum (Vendor Usage = 64)
    0x15, 0x00,             //      Logical Minimum (Vendor Usage = 0)
    0x26, 0xFF, 0x00,       //      Logical Maximum (Vendor Usage = 255)
    0x75, 0x08,             //      Report Size (Vendor Usage = 8)
//    0x95, 0x08,             //      Report Count (Vendor Usage = 8)
    0x95, 0x40,             //      Report Count (Vendor Usage = 64)
    0x81, 0x02,             //      Input (Data, Var, Abs)
    0x19, 0x01,             //      Usage Minimum (Vendor Usage = 1)
//    0x29, 0x08,             //      Usage Maximum (Vendor Usage = 8)
    0x29, 0x40,             //      Usage Maximum (Vendor Usage = 64)
    0x91, 0x02,             //      Output (Data, Var, Ads)
    0xC0};                  // End Collection

rom const unsigned char *rom USB_CD_Ptr[]={&cfg01,&cfg02};
rom const unsigned char *rom USB_SD_Ptr[]={&sd000,&sd001,&sd002,&sd003,&sd004};

rom pFunc ClassReqHandler[1]=
{
    &USBCheckHIDRequest
};

#pragma code

/** EOF usbdsc.c ****************************************************/

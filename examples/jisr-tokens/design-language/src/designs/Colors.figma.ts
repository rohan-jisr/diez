/**
 * This code was generated by Diez version 10.6.0.
 * Changes to this file may cause incorrect behavior and will be lost if the code is regenerated.
 */
import { Color, Font, GradientStop, LinearGradient, Point2D, Typograph } from "@diez/prefabs";

const colorsColors = {
    blue09: Color.rgba(250, 252, 255, 1),
    blue07: Color.rgba(242, 248, 255, 1),
    blue06: Color.rgba(229, 240, 255, 1),
    blue05: Color.rgba(205, 227, 255, 1),
    blue04: Color.rgba(154, 198, 255, 1),
    blue03: Color.rgba(53, 141, 255, 1),
    blue02: Color.rgba(3, 113, 255, 1),
    blue01: Color.rgba(0, 91, 209, 1),
    slate11: Color.rgba(253, 254, 254, 1),
    slate10: Color.rgba(251, 252, 253, 1),
    slate09: Color.rgba(249, 250, 251, 1),
    slate08: Color.rgba(246, 247, 249, 1),
    slate07: Color.rgba(237, 240, 243, 1),
    slate06: Color.rgba(219, 226, 231, 1),
    slate05: Color.rgba(183, 196, 208, 1),
    slate04: Color.rgba(147, 167, 184, 1),
    slate03: Color.rgba(111, 137, 161, 1),
    slate02: Color.rgba(75, 108, 137, 1),
    slate01: Color.rgba(43, 69, 93, 1),
    grey10: Color.rgba(255, 255, 255, 1),
    grey09: Color.rgba(246, 246, 246, 1),
    grey08: Color.rgba(226, 226, 226, 1),
    grey07: Color.rgba(214, 214, 214, 1),
    grey06: Color.rgba(180, 180, 180, 1),
    grey05: Color.rgba(144, 144, 144, 1),
    grey04: Color.rgba(128, 128, 128, 1),
    grey03: Color.rgba(96, 96, 96, 1),
    grey02: Color.rgba(64, 64, 64, 1),
    grey01: Color.rgba(32, 32, 32, 1),
    micsAgreement: Color.rgba(205, 84, 33, 1),
    micsPurpleLight: Color.rgba(90, 93, 251, 1),
    micsGreenLight: Color.rgba(74, 191, 48, 1),
    micsPurpleDark: Color.rgba(61, 64, 247, 1),
    micsGreenDark: Color.rgba(32, 178, 0, 1),
    micsInsurance: Color.rgba(186, 161, 16, 1),
    micsPrevious: Color.rgba(205, 91, 60, 1),
    micsCurrent: Color.rgba(90, 169, 23, 1),
    micsError: Color.rgba(219, 53, 53, 1),
    statusesRejected: Color.rgba(209, 50, 64, 1),
    statusesSuccessful: Color.rgba(87, 168, 3, 1),
    statusesProcessing: Color.rgba(220, 115, 0, 1),
    attendanceNotJoined: Color.rgba(244, 39, 133, 1),
    attendanceLeave: Color.rgba(149, 62, 246, 1),
    attendanceHoliday: Color.rgba(105, 174, 195, 1),
    attendanceAbsent: Color.rgba(233, 93, 32, 1),
    attendancePresent: Color.rgba(49, 180, 7, 1),
    shiftsSplit: Color.rgba(198, 51, 197, 1),
    shiftsMidnight: Color.rgba(228, 94, 34, 1),
    shiftsEvining: Color.rgba(51, 198, 174, 1),
    shiftsDay: Color.rgba(68, 83, 190, 1),
    notificationErrorLight: Color.rgba(255, 217, 217, 1),
    notificationErrorFaint: Color.rgba(255, 236, 236, 1),
    notificationSuccessDark: Color.rgba(104, 158, 56, 1),
    notificationSuccessLight: Color.rgba(216, 242, 209, 1),
    notificationErrorDark: Color.rgba(209, 50, 64, 1),
    notificationInprocessDark: Color.rgba(183, 137, 33, 1),
    notificationInprocessLight: Color.rgba(249, 237, 211, 1),
    payrollDeductionLight: Color.rgba(249, 227, 227, 1),
    payrollDeductionDark: Color.rgba(246, 104, 87, 1),
    payrollAdditionsLight: Color.rgba(219, 255, 255, 1),
    payrollAdditionsDark: Color.rgba(5, 220, 220, 1),
    payrollEarningLight: Color.rgba(243, 238, 255, 1),
    payrollEarningDark: Color.rgba(141, 91, 239, 1)
};

const colorsGradients = {
    blue08: new LinearGradient({ stops: [GradientStop.make(0, Color.rgba(247, 250, 255, 1)), GradientStop.make(1, Color.rgba(247, 250, 255, 1))], start: Point2D.make(-1e-14, 0.499999962643615), end: Point2D.make(0.99999999999999, 0.49999996340455) })
};

const colorsTypography = {
    titleMedium20: new Typograph({ letterSpacing: 0, fontSize: 20, lineHeight: 23.4375, color: Color.rgba(0, 0, 0, 1), font: new Font({ name: "Roboto-Medium" }) })
};

export const colorsTokens = {
    colors: colorsColors,
    gradients: colorsGradients,
    typography: colorsTypography
};

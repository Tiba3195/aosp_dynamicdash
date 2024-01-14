#ifndef GPIOCONTROL_H
#define GPIOCONTROL_H

#include <string>

class GPIOControl {
public:
    enum class Direction {
        IN,
        OUT
    };

    enum class PinValue  {
        LOW,
        HIGH
    };

    static int exportPin(int pin);
    static int unexportPin(int pin);
    static int setPinDirection(int pin, Direction direction);
    static int setPinValue(int pin, PinValue  value);
    static PinValue getPinValue(int pin);

private:
    static const std::string SYSFS_GPIO_DIR;
    static const std::string SYSFS_GPIO_EXPORT;
    static const std::string SYSFS_GPIO_UNEXPORT;

    static std::string getPinPath(int pin);
    static std::string getDirectionString(Direction direction);
    static std::string getPinValueString(PinValue value);
};

#endif // GPIOCONTROL_H
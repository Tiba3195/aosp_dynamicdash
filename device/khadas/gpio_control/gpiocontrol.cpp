#include "gpiocontrol.h"
#include <fcntl.h>
#include <unistd.h>
#include <cstdio>
#include <cstring>

const std::string GPIOControl::SYSFS_GPIO_DIR = "/sys/class/gpio/";
const std::string GPIOControl::SYSFS_GPIO_EXPORT = GPIOControl::SYSFS_GPIO_DIR + "export";
const std::string GPIOControl::SYSFS_GPIO_UNEXPORT = GPIOControl::SYSFS_GPIO_DIR + "unexport";

std::string GPIOControl::getPinPath(int pin) {
    return SYSFS_GPIO_DIR + "gpio" + std::to_string(pin);
}

std::string GPIOControl::getDirectionString(Direction direction) {
    return direction == Direction::IN ? "in" : "out";
}

std::string GPIOControl::getPinValueString(PinValue value) {
    return value == PinValue::LOW ? "0" : "1";
}

int GPIOControl::exportPin(int pin) {
    int fd = open(SYSFS_GPIO_EXPORT.c_str(), O_WRONLY);
    if (fd == -1) {
        perror("GPIO Export Open");
        return -1;
    }
    std::string pinStr = std::to_string(pin);
    if (write(fd, pinStr.c_str(), pinStr.length()) == -1) {
        perror("GPIO Export Write");
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}

int GPIOControl::unexportPin(int pin) {
    int fd = open(SYSFS_GPIO_UNEXPORT.c_str(), O_WRONLY);
    if (fd == -1) {
        perror("GPIO Unexport Open");
        return -1;
    }
    std::string pinStr = std::to_string(pin);
    if (write(fd, pinStr.c_str(), pinStr.length()) == -1) {
        perror("GPIO Unexport Write");
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}

int GPIOControl::setPinDirection(int pin, Direction direction) {
    std::string directionPath = getPinPath(pin) + "/direction";
    int fd = open(directionPath.c_str(), O_WRONLY);
    if (fd == -1) {
        perror("GPIO Direction Open");
        return -1;
    }
    std::string directionStr = getDirectionString(direction);
    if (write(fd, directionStr.c_str(), directionStr.length()) == -1) {
        perror("GPIO Direction Write");
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}

int  GPIOControl::setPinValue(int pin, PinValue value) {
    std::string valuePath = getPinPath(pin) + "/value";
    int fd = open(valuePath.c_str(), O_WRONLY);
    if (fd == -1) {
        perror("GPIO Value Open");
        return -1;
    }
    std::string valueStr = getPinValueString(value);
    if (write(fd, valueStr.c_str(), valueStr.length()) == -1) {
        perror("GPIO Value Write");
        close(fd);
        return -1;
    }
    close(fd);
    return 0;
}

GPIOControl::PinValue GPIOControl::getPinValue(int pin) {
    char buf[4];
    std::string valuePath = getPinPath(pin) + "/value";
    int fd = open(valuePath.c_str(), O_RDONLY);
    if (fd == -1) {
        perror("GPIO Value Open");
        return PinValue::LOW; // Default return value in case of error
    }
    if (read(fd, buf, sizeof(buf)) == -1) {
        perror("GPIO Value Read");
        close(fd);
        return PinValue::LOW; // Default return value in case of error
    }
    close(fd);
    return std::string(buf) == "0" ? PinValue::LOW : PinValue::HIGH;
}
#!/bin/bash

# GPIO numbers (sysfs)
# GPIO PIN 512 + 4 = 516
# GPIO PIN 512 + 17 = 529
GPIO_IN=516
GPIO_OUT=529

GPIO_PATH=/sys/class/gpio

# Export GPIOs if not already exported
if [ ! -d "$GPIO_PATH/gpio$GPIO_IN" ]; then
    echo $GPIO_IN > $GPIO_PATH/export
fi

if [ ! -d "$GPIO_PATH/gpio$GPIO_OUT" ]; then
    echo $GPIO_OUT > $GPIO_PATH/export
fi

# Set directions
echo in  > $GPIO_PATH/gpio$GPIO_IN/direction
echo out > $GPIO_PATH/gpio$GPIO_OUT/direction

# Enable edge detection
echo both > $GPIO_PATH/gpio$GPIO_IN/edge

# Clear any prior interrupt
cat $GPIO_PATH/gpio$GPIO_IN/value > /dev/null

# Main loop
while true; do
    read value < $GPIO_PATH/gpio$GPIO_IN/value

    if [ "$value" -eq 1 ]; then
        echo 1 > $GPIO_PATH/gpio$GPIO_OUT/value
    else
        echo 0 > $GPIO_PATH/gpio$GPIO_OUT/value
    fi

    # Small debounce
    sleep 0.05
done
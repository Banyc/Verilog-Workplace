# VGA driver

## Tutorial

### Principle of VGA

- <https://youtu.be/eJMYVLPX0no>
    - The electronic mapping
        - when facing the monitor, pixel from left to right
        - when meets the end, return to the next line and resume the above step
    - timing periods
        - front porch
            - to slow down the moving of the direction of the electronic gun
            - to slow down the shooting speed of the electron
        - back porch
            - to speed up the moving of the direction of the electronic gun
            - to speed up the shooting speed of the electron
        - sync
            - to stop electronic shooting
            - to direct the gun to the beginning
        - active video

- <https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml>
    - when the time goes to the vertical front porch, horizontal timing periods remain the same though active video period gives nothing.

- <https://images.app.goo.gl/duo74MiD2Vcu1TaBA>
    - wave for sync

- <https://timetoexplore.net/blog/arty-fpga-vga-verilog-01>
    - useless

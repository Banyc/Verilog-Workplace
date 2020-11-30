# Verilog Workplace

## Test by IVerilog

1. Move file `COMPONENT_tb.v` to this directory;
1. Run:

    ```
    make aCOMPONENT_tb
    ```

1. Run:

    ```
    make wCOMPONENT_tb
    ```

## Build on the board

> Not recommended.

1. Move `Top.v` and UCF file out to the same directory as this readme
1. copy all files and directories at the same directory as this readme to the project folder
1. Load to the board

## License

EVERYTHING UNDER THE SAME DIRECTORY IS OWNED BY 3170106317 AND IS PRIVATE, AND SHALL NOT BE RE-DISTRIBUTED.

## Tutorial

-   <https://www.fpga4student.com/>
-   blocking vs non-blocking - <https://youtu.be/kwgvU2MIq1I>

## Notes

<details>
    <summary> Outdated read problem </summary>

### Outdated read problem

```verilog
always @(state) began
    case (state)
        state1: began
            shiftRegister = 1;
        end
        state2: began
            // read register
        end
    endcase
end
```

... When reading the register, the value has not been shifted.

To solve the problem (to get the updated value):

```verilog
always @(*) began
    case (state)
        state1: began
            shiftRegister = 1;
        end
        state2: began
            // read register
        end
    endcase
end
```

</detail>

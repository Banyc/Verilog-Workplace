
```graphviz
digraph state_machine {
    rankdir=LR;
    size="8,5"
    compound=true;

    node [shape = circle];

    subgraph cluster_save_or_shift {
        save_or_shift[shape="none"][style="invis"][label=""];
        cluster_save_or_shift_start [shape = point];
        save;
        shift_1;

        cluster_save_or_shift_start -> save;
        cluster_save_or_shift_start -> shift_1;
    };
    reset -> save_or_shift [lhead="cluster_save_or_shift"];
    save -> shift_2;
    shift_2 -> save_or_shift [lhead="cluster_save_or_shift"];

    <!-- shift_1 -> save_or_shift [lhead="cluster_save_or_shift"]; -->
    shift_1_TO_save_or_shift [shape=point height=0];
    shift_1 -> shift_1_TO_save_or_shift:n [dir = none];
    shift_1_TO_save_or_shift:s -> save_or_shift [lhead="cluster_save_or_shift"];
}
```

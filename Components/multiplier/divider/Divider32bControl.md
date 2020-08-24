
```graphviz
digraph state_machine {
    rankdir=LR;
    size="8,5"
    compound=true;

    node [shape = circle];

    subgraph cluster_afterSub {
        label = "afterSub";
        afterSub[shape="none"][style="invis"][label=""];
        cluster_afterSub_start [shape = point];
        add;
        shiftLeft_1;

        cluster_afterSub_start -> add [label="failed"];
        cluster_afterSub_start -> shiftLeft_1 [label="succeeded"];
    };
    reset -> sub;
    sub -> afterSub [lhead="cluster_afterSub"];
    sub -> halt;

    add -> shiftLeft_2;
    <!-- shiftLeft_2 -> append_0; -->
    shiftLeft_2 -> sub;

    shiftLeft_1 -> append_1;

    <!-- append_0 -> sub; -->
    append_1 -> sub;
}
```

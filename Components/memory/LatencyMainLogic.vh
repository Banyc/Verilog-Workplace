
    // limits the positive time of `hasFinished` to only one `clk` circle.
    reg shouldDeactivateFinish;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            hasFinished = 0;
            shouldDeactivateFinish = 1;
        end else begin
            if (en & hasTaskTriggered && !shouldDeactivateFinish) begin
                hasFinished = 1;
                shouldDeactivateFinish = 0;
            end else begin
                hasFinished = 0;
                if (hasTaskTriggered) begin
                    shouldDeactivateFinish = 1;
                end else begin
                    // prepare for the next `posedge hasTaskTriggered`
                    shouldDeactivateFinish = 0;
                end
            end
        end
    end

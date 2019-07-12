# Markdown mermaid
Shell script that generates mermaid diagrams into images from .md files

## Setup
``` bash
npm install mermaid.cli # or npm install -g mermaid.cli
sh shell.sh ${input_file} ${output_file} ${break_separator}# run script
# sh shell.sh ./mermaid/README.md README.md breakSept
```

### Example mermaid flowchart
```mermaid flow
graph TD;
    A-->B;
    A-->C;
    B-->D;
```

breakSept

### Example mermaid sequence diagram
```mermaid sequence
sequenceDiagram
    participant Alice
    participant Bob
    Alice->John: Hello John, how are you?
    loop Healthcheck
        John->John: Fight against hypochondria
    end
    Note right of John: Rational thoughts <br/>prevail...
    John-->Alice: Great!
    John->Bob: How about you?
    Bob-->John: Jolly good!
```

breakSept

### Example mermaid gantt diagram
```mermaid gantt
gantt
        dateFormat  YYYY-MM-DD
        title Adding GANTT diagram functionality to mermaid
        section A section
        Completed task            :done,    des1, 2014-01-06,2014-01-08
        Active task               :active,  des2, 2014-01-09, 3d
        Future task               :         des3, after des2, 5d
        Future task2               :         des4, after des3, 5d
        section Critical tasks
        Completed task in the critical line :crit, done, 2014-01-06,24h
        Implement parser and jison          :crit, done, after des1, 2d
        Create tests for parser             :crit, active, 3d
        Future task in critical line        :crit, 5d
        Create tests for renderer           :2d
        Add to mermaid                      :1d
```

breakSept
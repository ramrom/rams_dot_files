# MERMAID
- official: https://mermaid.js.org/
- decent cheat: https://jojozhuang.github.io/tutorial/mermaid-cheat-sheet/ 
- github renders mermaid code blocks! 💛 - https://github.blog/2022-02-14-include-diagrams-markdown-files-mermaid/

## FLOW CHART
```mermaid
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
```

## SEQUENCE DIAGRAM
```mermaid
sequenceDiagram
    A-->B: some info
    activate B
    B-->A: return info<br/>with new line
    deactivate B
```

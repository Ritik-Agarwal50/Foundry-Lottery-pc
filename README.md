<!-- @format -->

```
vm.wrap()
```

-> This allows us to set block.timestamp manually in testing env.

```
vm.roll()
```

-> This allow us to set block.number manually in testing env.

```
forge coverage --report debug > coverage.txt
```
-> This command will tell which line we haven't debug, and it will store all the details to the coverage.txt file

```
vm.recordLogs 
```
-> Tells the VM To start recording all thee emitted Event To access them use 

```

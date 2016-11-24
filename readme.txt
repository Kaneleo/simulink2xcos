This toolbox allows you to recreate a matlab simulink diagram in xcos automatically.
Blocks that are supported up until now are:

Constant
Integrator
Gain
Sum
ToWorkspace
Mux
Demux
Goto
From
SubSystem
Inport
Outport
Product
Scope
Derivative
Trigonometry
Reference
Fcn
BusCreator
BusSelector
BusAssignment

All bus related blocks will only work, if the output data type of the bus blocks in simulink is a BusObject (with the representative name).
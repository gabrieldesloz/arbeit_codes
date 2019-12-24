-- vhdl attributes ---

T'BASE       is the base type of the type T
T'LEFT       is the leftmost value of type T. (Largest if downto)
T'RIGHT      is the rightmost value of type T. (Smallest if downto)
T'HIGH       is the highest value of type T.
T'LOW        is the lowest value of type T.
T'ASCENDING  is boolean true if range of T defined with to .
T'IMAGE(X)   is a string representation of X that is of type T.
T'VALUE(X)   is a value of type T converted from the string X.
T'POS(X)     is the integer position of X in the discrete type T.
T'VAL(X)     is the value of discrete type T at integer position X.
T'SUCC(X)    is the value of discrete type T that is the successor of X.
T'PRED(X)    is the value of discrete type T that is the predecessor of X.
T'LEFTOF(X)  is the value of discrete type T that is left of X.
T'RIGHTOF(X) is the value of discrete type T that is right of X.
A'LEFT       is the leftmost subscript of array A or constrained array type.
A'LEFT(N)    is the leftmost subscript of dimension N of array A.
A'RIGHT      is the rightmost subscript of array A or constrained array type.
A'RIGHT(N)   is the rightmost subscript of dimension N of array A.
A'HIGH       is the highest subscript of array A or constrained array type.
A'HIGH(N)    is the highest subscript of dimension N of array A.
A'LOW        is the lowest subscript of array A or constrained array type.
A'LOW(N)     is the lowest subscript of dimension N of array A.
A'RANGE      is the range  A'LEFT to A'RIGHT  or  A'LEFT downto A'RIGHT .
A'RANGE(N)   is the range of dimension N of A.
A'REVERSE_RANGE  is the range of A with to and downto reversed.
A'REVERSE_RANGE(N)  is the REVERSE_RANGE of dimension N of array A.
A'LENGTH     is the integer value of the number of elements in array A.
A'LENGTH(N)  is the number of elements of dimension N of array A.
A'ASCENDING  is boolean true if range of A defined with to .
A'ASCENDING(N)  is boolean true if dimension N of array A defined with to .
S'DELAYED(t) is the signal value of S at time now - t .
S'STABLE     is true if no event is occurring on signal S.
S'STABLE(t)  is true if no even has occurred on signal S for t units of time.
S'QUIET      is true if signal S is quiet. (no event this simulation cycle)
S'QUIET(t)   is true if signal S has been quiet for t units of time.
S'TRANSACTION  is a bit signal, the inverse of previous value each cycle S is active.
S'EVENT      is true if signal S has had an event this simulation cycle.
S'ACTIVE     is true if signal S is active during current simulation cycle.
S'LAST_EVENT is the time since the last event on signal S.
S'LAST_ACTIVE  is the time since signal S was last active.
S'LAST_VALUE is the previous value of signal S.
S'DRIVING    is false only if the current driver of S is a null transaction.
S'DRIVING_VALUE  is the current driving value of signal S.
E'SIMPLE_NAME  is a string containing the name of entity E.
E'INSTANCE_NAME  is a string containing the design hierarchy including E.
E'PATH_NAME  is a string containing the design hierarchy of E to design root.
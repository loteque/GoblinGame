class_name Machine extends Resource

class State
    func enter():
        signal state_entered
        state_entered.emit()
        pass

    func exit():
        signal state_exited
        state_exited.emit
        pass

    func update():
        pass
    
    func init():
        pass

class BehaviorStack extends State

    var _stack: Array[State] = []
    var _current_state: State

    func push(state: State)
        _stack.push_front(state)
    
    func pop()
        _current_state = _stack[0]
        await _current_state.enter().state_entered 
        _stack[idx].delete() 

    func interupt(state: State)
        var idx = _current_state.get_index()
        _stack.insert_at(state, idx)
        var new_state = _stack[idx + 1]
        _current_state.exit()
        new_state.enter()
        _current_state = new_state

class Motivator
    var target_state: State 
    var condition: Callable
    var is_interupt: bool
    var stack: BehaviorStack

    func change_state(stack, target_state, condition, is_interupt)
        if !condition:
            return  

        if is_interupt:
            stack.interupt(target_state)
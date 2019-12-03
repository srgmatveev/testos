
typedef void (*constructor)();

extern "C" constructor start_ctors;
extern "C" constructor end_ctors;

extern "C" void initializeConstructors();

void initializeConstructors() {
    for (constructor *i = &start_ctors; i != &end_ctors; ++i)
        (*i)();
}
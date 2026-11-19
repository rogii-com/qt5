#include <QCoreApplication>

#include <cstdio>

// The second application object trips a Q_ASSERT_X inside qcoreapplication.cpp: the check
// lives in the Qt library, so it fires only with the asserts variant.
int main(int argc, char **argv)
{
    QCoreApplication first(argc, argv);
    QCoreApplication second(argc, argv);
    std::puts("no assert fired");
    return 0;
}

#include <QCoreApplication>

#include <cstdio>

#if defined(_MSC_VER)
#include <crtdbg.h>
#include <stdlib.h>
#endif

// The second application object trips a Q_ASSERT_X inside qcoreapplication.cpp: the check
// lives in the Qt library, so it fires only with the asserts variant or the Debug libraries.
int main(int argc, char **argv)
{
#if defined(_MSC_VER)
    // Without this the Debug CRT waits on an abort dialog, and the test job hangs.
    _set_abort_behavior(0, _WRITE_ABORT_MSG | _CALL_REPORTFAULT);
    _CrtSetReportMode(_CRT_ERROR, _CRTDBG_MODE_FILE);
    _CrtSetReportFile(_CRT_ERROR, _CRTDBG_FILE_STDERR);
#endif

    QCoreApplication first(argc, argv);
    QCoreApplication second(argc, argv);
    std::puts("no assert fired");
    return 0;
}

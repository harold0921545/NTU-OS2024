from gradelib import *

r = Runner()


@test(5, "mp0 command with public testcase 0")
def test_mp0_0():
    r.run_qemu(shell_script([
        'testgen',
        'mp0 os2202 a',
    ]))
    r.match(
        'os2202 [error opening dir]',
        '',
        '0 directories, 0 files',
    )


@test(5, "mp0 command with public testcase 1")
def test_mp0_1():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 os2202/ o',
    ]))
    r.match(
        'os2202/ [error opening dir]',
        '',
        '0 directories, 0 files',
    )


@test(5, "mp0 command with public testcase 2")
def test_mp0_2():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 os2023 o',
    ]))
    r.match(
        'os2023 1',
        'os2023/d1 1',
        'os2023/d2 1',
        'os2023/d2/a 1',
        'os2023/d2/b 1',
        'os2023/d2/c 1',
        'os2023/d3 1',
        'os2023/d3/a 1',
        'os2023/d3/b 1',
        '',
        '6 directories, 2 files',
    )


@test(5, "mp0 command with public testcase 3")
def test_mp0_3():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 os2023/ o',
    ]))
    r.match(
        'os2023/ 1',
        'os2023//d1 1',
        'os2023//d2 1',
        'os2023//d2/a 1',
        'os2023//d2/b 1',
        'os2023//d2/c 1',
        'os2023//d3 1',
        'os2023//d3/a 1',
        'os2023//d3/b 1',
        '',
        '6 directories, 2 files',
    )


@test(10, "mp0 command with public testcase 4")
def test_mp0_4():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 a a',
    ]))
    r.match(
        'a 1',
        'a/0 1',
        'a/1 1',
        'a/2 1',
        'a/3 1',
        'a/4 1',
        'a/5 1',
        'a/6 1',
        'a/7 1',
        'a/8 1',
        'a/9 1',
        'a/10 1',
        '',
        '11 directories, 0 files',
    )

@test(10, "mp0 command with public testcase 5")
def test_mp0_5():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 a/ a',
    ]))
    r.match(
        'a/ 1',
        'a//0 1',
        'a//1 1',
        'a//2 1',
        'a//3 1',
        'a//4 1',
        'a//5 1',
        'a//6 1',
        'a//7 1',
        'a//8 1',
        'a//9 1',
        'a//10 1',
        '',
        '11 directories, 0 files',
    )

@test(10, "mp0 command with custom testcase 1")
def test_mp0_6():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 a/..//a/ a',
    ]))
    r.match(
        'a/..//a/ 2',
        'a/..//a//0 2',
        'a/..//a//1 2',
        'a/..//a//2 2',
        'a/..//a//3 2',
        'a/..//a//4 2',
        'a/..//a//5 2',
        'a/..//a//6 2',
        'a/..//a//7 2',
        'a/..//a//8 2',
        'a/..//a//9 2',
        'a/..//a//10 2',
        '',
        '11 directories, 0 files',
    )

@test(10, "mp0 command with custom testcase 2")
def test_mp0_7():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 ./././a/ a',
    ]))
    r.match(
        './././a/ 1',
        './././a//0 1',
        './././a//1 1',
        './././a//2 1',
        './././a//3 1',
        './././a//4 1',
        './././a//5 1',
        './././a//6 1',
        './././a//7 1',
        './././a//8 1',
        './././a//9 1',
        './././a//10 1',
        '',
        '11 directories, 0 files',
    )

@test(10, "mp0 command with custom testcase 3")
def test_mp0_8():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 //./a/ a',
    ]))
    r.match(
        '//./a/ 1',
        '//./a//0 1',
        '//./a//1 1',
        '//./a//2 1',
        '//./a//3 1',
        '//./a//4 1',
        '//./a//5 1',
        '//./a//6 1',
        '//./a//7 1',
        '//./a//8 1',
        '//./a//9 1',
        '//./a//10 1',
        '',
        '11 directories, 0 files',
    )

@test(10, "mp0 command with custom testcase 4")
def test_mp0_9():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 ../b b',
    ]))
    r.match(
        '../b 1',
        '../b/0 1',
        '../b/1 1',
        '../b/2 1',
        '../b/3 1',
        '../b/4 1',
        '../b/5 1',
        '../b/6 1',
        '../b/7 1',
        '../b/8 1',
        '../b/9 1',
        '../b/10 1',
        '',
        '0 directories, 11 files',
    )

@test(10, "mp0 command with custom testcase 5")
def test_mp0_10():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 ../b b',
    ]))
    r.match(
        '../b 1',
        '../b/0 1',
        '../b/1 1',
        '../b/2 1',
        '../b/3 1',
        '../b/4 1',
        '../b/5 1',
        '../b/6 1',
        '../b/7 1',
        '../b/8 1',
        '../b/9 1',
        '../b/10 1',
        '',
        '0 directories, 11 files',
    )

@test(10, "mp0 command with custom testcase 6")
def test_mp0_11():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 os2023//d2 o',
    ]))
    r.match(
        'os2023//d2 1',
        'os2023//d2/a 1',
        'os2023//d2/b 1',
        'os2023//d2/c 1',
        '',
        '2 directories, 1 files',
    )

@test(10, "mp0 command with custom testcase 7")
def test_mp0_12():
    r.run_qemu(shell_script([
        # 'testgen',
        'mp0 longstring a',
    ]))
    r.match(
        'longstring 0',
        'longstring/longstring 0',
        'longstring/longstring/longstring 0',
        'longstring/longstring/longstring/nevergonna 1',
        'longstring/longstring/longstring/nevergonna/giveyouupp 1',
        'longstring/longstring/shihhhhhhh 0',
        'longstring/longstring/shihhhhhhh/guangggggg 1',
        'longstring/longstring/shihhhhhhh/guangggggg/linggggggg 1',
        'longstring/aaaaaaaaaa 10',
        'longstring/aaaaaaaaaa/aaaaaaaaaa 20',
        'longstring/aaaaaaaaaa/aaaaaaaaaa/aaaaaaaaaa 30',
        'longstring/aaaaaaaaaa/aaaaaaaaaa/aaaaaaaaaa/aaaaaaaaaa 40',
        '',
        '11 directories, 0 files',
    )

run_tests()

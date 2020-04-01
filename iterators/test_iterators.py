from sys import stdout

from iterators import Example


def main():
    e = Example()

    e.add('a')
    e.add('b')
    e.add('c')

    print([s for s in e.strings()])


if __name__ == '__main__':
    main()

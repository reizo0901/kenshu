import sys

def main(code, name):
    print('main shori!')
    print('code=[' + code + '] name=[' + name + ']')

if  __name__ == '__main__':
    args = sys.argv

    if len(args) == 3:
        code = args[1]
        name = args[2]
        main(code,name)
    else:
        print('code and name input option!')
        print('$ sample.py <code> <name>')
        quit()

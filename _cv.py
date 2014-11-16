from collections import namedtuple
import yaml
import re
import sys

USAGE = """Usage: python3 _cv.py <cv file> ...

CV filename should be in format `_cv.XX.yml`,
where `XX` is two-letter language index.
Output will be stored in `cv.XX.md`
"""

def usage(error_message):
	if error_message:
		print(error_message)
	print(USAGE)

def to_struct(name, data):
	if isinstance(data, dict):
		T = namedtuple(name, data.keys())
		return T(*[to_struct(k.title(), v) for k, v in data.items()])
	elif isinstance(data, list):
		return [to_struct('YAMLList', x) for x in data]
	return data

def main():
	if len(sys.argv) < 2:
		usage()
		return 1

	with open("_cv.md", "r") as f:
		template = f.read()
	for filename in sys.argv[1:]:
		m = re.match(r'_cv.([a-z]{2}).yml', filename)
		if not m:
			usage("Wrong format of CV file name: " + filename)
			return 1
		lang = m.group(1)
		dest_filename = "cv.{0}.md".format(lang)

		with open(filename, "r") as f:
			data = yaml.load(f)
		try:
			data = to_struct('CVTemplate', data)
			with open(dest_filename, "w") as f:
				f.write(template.format(**(data.__dict__)))
		except KeyError as e:
			print("{0}: missing {1} group".format(filename, e))
			return 1
		except AttributeError as e:
			print("{0}: {1}".format(filename, e))
			return 1

if __name__ == "__main__":
	retcode = main()
	sys.exit(retcode)

from collections import namedtuple
import yaml

def to_struct(data):
	if isinstance(data, dict):
		return namedtuple('Struct', data.keys())(*[to_struct(x) for x in data.values()])
	elif isinstance(data, list):
		return [to_struct(x) for x in data]
	return data

def main():
	with open("_cv.md", "r") as f:
		template = f.read()

	with open("_cv.en.yml", "r") as f:
		data = yaml.load(f)
	data = to_struct(data)
	with open("cv.en.md", "w") as f:
		f.write(template.format(**(data.__dict__)))

	with open("_cv.ru.yml", "r") as f:
		data = yaml.load(f)
	data = to_struct(data)
	with open("cv.ru.md", "w") as f:
		f.write(template.format(**(data.__dict__)))

if __name__ == "__main__":
	main()

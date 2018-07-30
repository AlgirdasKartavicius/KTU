"""
Problem: 1241 - Jollybee Tournament
Link: https://uva.onlinejudge.org/index.php?option=com_onlinejudge&Itemid=8&category=247&page=show_problem&problem=3682
Mangirdas Kazlauskas IFF-4/1
"""


from math import pow


class Tournament:
	def __init__(self, n, m_list):
		self._n = n
		self._m_list = m_list

	def n(self):
		return self._n

	def m_list(self):
		return self._m_list


def read_input():
	t = int(input())
	n_list = list()
	m_lists = list()
	for i in range(t):
		n, _ = [int(x) for x in input().split()]
		m_list = [int(x) for x in input().split()]
		n_list.append(n)
		m_lists.append(m_list)
	return n_list, m_lists


def print_output(result):
	for i in result:
		print(i)


def read_from_file(filename):
	with open(filename, mode='rt') as f:
		t = int(next(f))
		n_list = list()
		m_lists = list()
		for i in range(t):
			n, _ = [int(x) for x in next(f).split()]
			m_list = [int(x) for x in next(f).split()]
			n_list.append(n)
			m_lists.append(m_list)
	return n_list, m_lists


def print_to_file(filename, results):
	with open(filename, mode='wt') as f:
		f.writelines("{}\n".format(i) for i in results)


def init_tournaments(n_list, m_lists):
	tournaments = [Tournament(n_list[x], m_lists[x]) for x in range(len(n_list))]
	return tournaments


def calculate_walkover_matches(tournament):
	walkover_matches_counter = 0
	participants_list = [0 if i+1 in tournament.m_list() else 1 for i in range(int(pow(2, tournament.n())))]
	while len(participants_list) > 1:
		iterator = iter(participants_list)
		new_participants_list = list()
		for i in iterator:
			status, increment = get_match_status(i, next(iterator))
			new_participants_list.append(status)
			walkover_matches_counter += increment
		participants_list = new_participants_list
	return walkover_matches_counter


def get_match_status(x, y):
	if x != y:
		return 1, 1
	elif x == y and x == 1:
		return 1, 0
	else:
		return 0, 0


def main(io_file=True, input_file='data.txt', output_file='results.txt'):
	input_output_file = io_file
	if input_output_file:
		n_list, m_lists = read_from_file(input_file)
	else:
		n_list, m_lists = read_input()
	tournaments = init_tournaments(n_list, m_lists)
	walkover_matches_list = [calculate_walkover_matches(tournament) for tournament in tournaments]
	if input_output_file:
		print_to_file(output_file, walkover_matches_list)
	else:
		print_output(walkover_matches_list)


if __name__ == '__main__':
	main()

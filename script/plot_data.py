import pandas as pd
import matplotlib.pyplot as plt


def parse_file(file_path):
    data = {
        'Iteration': [],
        'Done rate': [],
        'Dead rate': [],
        'Out of time rate': [],
        'Average completion time': [],
        'Best time': []
    }

    with open(file_path, 'r') as file:
        current_iteration = None
        for line in file:
            if line.startswith("Iteration:"):
                current_iteration = int(line.split()[1])
                data['Iteration'].append(current_iteration)

                for key in data.keys():
                    if key != 'Iteration' and len(data[key]) < len(data['Iteration']):
                        data[key].append(None)

            elif line.startswith("Done rate:"):
                while len(data['Done rate']) < len(data['Iteration']):
                    data['Done rate'].append(None)
                data['Done rate'][-1] = float(line.split(':')[1])

            elif line.startswith("Dead rate:"):
                while len(data['Dead rate']) < len(data['Iteration']):
                    data['Dead rate'].append(None)
                data['Dead rate'][-1] = float(line.split(':')[1])

            elif line.startswith("Out of time rate:"):
                while len(data['Out of time rate']) < len(data['Iteration']):
                    data['Out of time rate'].append(None)
                data['Out of time rate'][-1] = float(line.split(':')[1])

            elif line.startswith("Average completion time:"):
                value = line.split(':')[1].strip()
                while len(data['Average completion time']) < len(data['Iteration']):
                    data['Average completion time'].append(None)
                data['Average completion time'][-1] = float(value) if value != 'nan' else None

            elif line.startswith("Best time:"):
                value = line.split(':')[1].strip()
                while len(data['Best time']) < len(data['Iteration']):
                    data['Best time'].append(None)
                data['Best time'][-1] = float(value) if value != 'inf' else None

        max_length = len(data['Iteration'])
        for key in data.keys():
            while len(data[key]) < max_length:
                data[key].append(None)

    return pd.DataFrame(data)


def plot_metrics(df1, df2, metric, output_file):
    plt.figure(figsize=(12, 6))

    df1 = df1.dropna(subset=[metric]).reset_index(drop=True)
    df2 = df2.dropna(subset=[metric]).reset_index(drop=True)

    plt.subplot(1, 2, 1)
    plt.plot(df1['Iteration'], df1[metric], label="Stable lines")
    plt.title(f"{metric} - Stable lines")
    plt.xlabel("Iteration")
    plt.ylabel(metric)
    plt.grid(True)

    plt.subplot(1, 2, 2)
    plt.plot(df2['Iteration'], df2[metric], label="Clean RL", color='orange')
    plt.title(f"{metric} - Clean RL")
    plt.xlabel("Iteration")
    plt.ylabel(metric)
    plt.grid(True)

    plt.tight_layout()
    plt.savefig(output_file)
    plt.close()


file1 = 'output_stable.txt'
file2 = 'output_clean.txt'

data1 = parse_file(file1)
data2 = parse_file(file2)

metrics = ["Done rate", "Dead rate", "Out of time rate", "Average completion time", "Best time"]

for metric in metrics:
    output_file = f"{metric.replace(' ', '_')}_comparison.png"
    plot_metrics(data1, data2, metric, output_file)

print("DONE")

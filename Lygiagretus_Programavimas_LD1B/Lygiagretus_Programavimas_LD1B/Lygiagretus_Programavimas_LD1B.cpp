// Lygiagretus_Programavimas_LD1.cpp : This file contains the 'main' function. Program execution begins and ends there.
//

#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <thread>
#include <condition_variable>
#include <math.h>
#include <iomanip>      // std::setw
#include <omp.h>
using namespace std;
int MAX_ITEMS = 25;
int NUMBER_OF_THREADS = 20;
int MAX_ELEM_MONITOR = 5;
struct Car
{
    string name;
    int rida;
    double kaina;

    double intrestingNumber() {
        int x = 0;
        for (int i = 0; i < 1000; i++) {
            x += pow((sqrt((sqrt(rida) * sqrt(kaina)))), 20.0);
        }
        return x;
    }
};



class Monitor {
private:
    int size;
    int capacity;
    condition_variable cv;
    mutex m;
    Car* list;
    bool finished;
public:
    Monitor(int size) {
        list = new Car[size];
        this->size = 0;
        this->capacity = MAX_ELEM_MONITOR;
        this->finished = false;
    }


    void addCar(Car& car) {
        while (this->size == capacity) {
        }
        #pragma omp critical
        {
            if (this->size != this->capacity) {
                list[size++] = car;
            }
        }


    }

    Car getCar() {
        Car result;
        while (size == 0 && !finished) {
        }
    #pragma omp critical
        {
            if (size != 0) {
                result = list[size - 1];
                size--;
            }
        }
        return result;
    }

    int getSize() {
        return this->size;
    }

    void dataFinishedLoading() {
        this->finished = true;
    }
    bool isFinished() {
        return this->finished;
    }
};



class ResultMonitor {
private:
    int size;
    int capacity;
    condition_variable cv;
    mutex m;
    Car* list;


public:

    ResultMonitor(int size) {
        list = new Car[size];
        this->size = 0;
        this->capacity = size;
    }

    void add(Car& new_car, bool sorted) {
        {
            while (this->size == this->capacity) {
            }

            #pragma omp critical
            {
                if (this->size != this->capacity) {
                    if (!sorted) {
                        list[size++] = new_car;
                    }
                    else {
                        int index = find_index(new_car);
                        shift_list(index);
                        list[index] = new_car;
                        size++;
                    }
                }

            }
        }

    }

    void shift_list(int index) {
        for (int i = size; i > index; i--) {
            list[i] = list[i - 1];
        }
    }

    int find_index(Car& car) {
        int condition = car.intrestingNumber();
        int index = 0;

        for (unsigned int i = 0; i < size; i++) {
            if (condition < list[i].intrestingNumber())
                return i;

            index++;
        }

        return index;
    }

    Car get(int index) {
        Car found_car;
        m.lock();

        found_car = list[index];
        m.unlock();
        return found_car;
    }

    int getSize() {
        return size;
    }
};


void readFromFile(vector<Car>& data, string name) {
    ifstream file;

    file.open(name);
    string carName;
    string rida;
    string kaina;
    while (getline(file, carName, ',')) {
        getline(file, rida, ',');
        getline(file, kaina, '\n');
        Car temp;
        temp.name = carName;
        temp.rida = atoi(rida.c_str());
        temp.kaina = atof(kaina.c_str());
        data.emplace_back(temp);
    }

}


void filterCars(Monitor& work_list, ResultMonitor& results) {
    while (work_list.getSize() != 0) {
        Car current_car = work_list.getCar();
        int filter_number = current_car.rida;
        if (current_car.name.empty()) {
            continue;
        }
        if (filter_number < 1000000) {
            results.add(current_car, true);
        }
    }
}

void write_processed_element_table_txt(string file_name, vector<Car> initial, ResultMonitor& data)
{
    ofstream rez(file_name);
    if (!rez.is_open()) { cerr << "Unable to create file"; exit(1); }

    rez << "+-----------------------------------------------------+" << endl;
    rez << "|                   Initial data                      |" << endl;
    rez << "+-----------------+-----------------+-----------------+" << endl;
    rez << "| " << setw(15) << "Name" << " | " << setw(15) << "Rida" << " | " << setw(15) << "Kaina" << " |" << endl;
    for (auto element : initial)
    {
        rez << "+-----------------+-----------------+-----------------+" << endl;
        rez << "| " << setw(15) << element.name << " | " << setw(15) << element.rida << " | " << setw(15) << element.kaina << " |" << endl;
    }
    rez << "+-----------------+-----------------+-----------------+" << endl;

    rez << endl;

    rez << "+-----------------------------------------------------------------------+" << endl;
    rez << "|                                 Results                               |" << endl;
    rez << "+-----------------+-----------------+-----------------+-----------------+" << endl;
    rez << "| " << setw(15) << "Name" << " | " << setw(15) << "Rida" << " | " << setw(15) << "Kaina" << " | " << setw(15) << "Magiskas sk" << " |" << endl;
    for (int i = 0; i < data.getSize(); i++)
    {
        rez << "+-----------------+-----------------+-----------------+-----------------+" << endl;
        rez << "| " << setw(15) << data.get(i).name << " | " << setw(15) << data.get(i).rida << " | " << setw(15) << data.get(i).kaina << " | " << setw(15) << data.get(i).intrestingNumber() << " |" << endl;
    }
    rez << "+-----------------+-----------------+-----------------+-----------------+" << endl;
}


int main()
{
    vector<Car> testData;
    ResultMonitor results(MAX_ITEMS);
    testData.reserve(MAX_ITEMS);
    vector<thread> threads;
    threads.reserve(NUMBER_OF_THREADS);
    Monitor mon(MAX_ELEM_MONITOR);
    readFromFile(testData, "test.txt");


#pragma omp parallel num_threads(NUMBER_OF_THREADS)
    {
        // Main thread ( ) 
        if (omp_get_thread_num() == 0) {
            for (Car& car : testData) {
                mon.addCar(car);
            }

        }
        else {
            // Other threads
            filterCars(mon, results);
        }
    }

    write_processed_element_table_txt("results.txt", testData, results);





}




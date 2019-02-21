#!/bin/bash

# Объявляем переменные принтера и папки с файлом
PRINTER='Samsung_SCX-4200_Series'
SPOOL_DIR='/srv/pdf_print'

# Запуск утилиты в режиме монитора
# где inotifywait утилитв из пакета inotify-tools 
# -m режим мониторинга (то есть непрерывно чекать состояние файла или папки)
# --format'%f'  форматирование вывода до имени файла, отсекает ненужную инфу
# -e close_write тип события которое отлеживать
# в случае close_write отслеживать закрытие файла открытого до етого на запись
# срабатывает при завершении копирования
# $SPOOL_DIR указание за каким каталогом следить
# while read PRINT_FILE  читать вывод предыдущей команды в переменную
# и за проход цыкла брать по одной

# создаем функцию с командами для выполнения в фоне 
print_file() {

	lpr -P $PRINTER "$SPOOL_DIR/$PRINT_FILE"  # Напечатать файл
	sleep 1m
	rm "$SPOOL_DIR/$PRINT_FILE"    # Удалить отпечатаный файл
}

inotifywait -m --format '%f' -e close_write $SPOOL_DIR 2>/dev/null | while read PRINT_FILE ;

	do
echo "$SPOOL_DIR/$PRINT_FILE" 
		if # Проверить является ли файл PDF или TXT
		    [ ${PRINT_FILE##*.} = pdf ] || [ ${PRINT_FILE##*.} = PDF ] || [ ${PRINT_FILE##*.} = txt ] || [ ${PRINT_FILE##*.} = TXT ]
		then
		    print_file "$SPOOL_DIR/$PRINT_FILE" & 	# запуск функции в фоне
		fi
	done

# Домашнее задание к занятию "`10.3 Pacemaker`" - `Roman Safin`


---

### Задание 1
Pacemaker это менеджер ресурсов кластера, который стремиться к достижению максимальной доступности вверенных ему ресурсов. 
Pacemaker состоит из нескольких частей
- CIB Cluster Information Base - БД которая содержит конфиг кластера и состояние ресурсов кластера. Руками не редактировать
- Stonithd - механизм который позволяет кластеру выключать/ребутать ноду, передавать его ресурсы другой ноде для предотвращения сбоя всего кластера. 
- PEngine - механизм политики, он рассчитывает идельное состояние кластера. Если что-то упало, то PEngine сделает перерасчет и передаст данные в CRMd 
- Cluster Resource Management Daemon (CRMd) - демон управления ресурсом кластера.  PEngine выбирает CRMd на какой-то одной ноде. Если эта нода падает, то выбирается другая главной(DC (Designated Controller)). Он получает инструкции от PEngine и передает их в свой LRMd или CRMd других нод(а те в свои LRMd).
- LRMd - это демон управления локальными ресурсами ноды. Он получает инструкции от локальной CRMd и возвращает результаты выполнения. Фактически это интерфейс между CRMd и ресурсами, работает на каждой ноде. 

---

### Задание 2
С помощью Corosync реализуется кластер.  Corosync отслеживает состояниет кластера и обеспечивает обмен сообщениями между нодами кластера, и на основании этих сообщений Pacemaker принимает решения такие как запуск/остановка служб, монтирование файловых систем и др. 

Настройки хранятся по пути /etc/corosync/corosync.conf

---

### Задание 3
Конфиги на обеих нодах не отличаются

totem {
    version: 2
    cluster_name: Twins
    secauth: off
    transport: udpu
}

nodelist {
    node {
        ring0_addr: brave
        nodeid: 1
    }

    node {
        ring0_addr: strong
        nodeid: 2
    }
}

quorum {
    provider: corosync_votequorum
    two_node: 1
}

logging {
    to_logfile: yes
    logfile: /var/log/cluster/corosync.log
    to_syslog: yes
}

---

### Задание 4
На обеих нодах одинаковые res-файлы, поэтому не буду дублировать
#### mysql

resource mysql {    
    protocol C;
    
    disk {
        fencing resource-only;
    }    
    
    handlers {
        fence-peer
"/usr/lib/drbd/crm-fence-peer.sh";
        after-resync-target
"/usr/lib/drbd/crm-unfence-peer.sh";
    }
syncer {
        rate 110M;
        
    }    
    on brave
    {        
        device /dev/drbd1;
        disk /dev/vg0/mysql;
        address 172.16.16.16:7798;
        meta-disk internal;
    }    
    on strong
    {        
        device /dev/drbd1;
        disk /dev/vg0/mysql;
        address 172.16.16.15:7798;
        meta-disk internal; 
    }

}

#### www

resource www {    
    protocol C;
    
    disk {
        fencing resource-only;
    }    
    
    handlers {
        fence-peer
"/usr/lib/drbd/crm-fence-peer.sh";
        after-resync-target
"/usr/lib/drbd/crm-unfence-peer.sh";
    }
syncer {
        rate 110M;
        
    }    
    on brave
    {        
        device /dev/drbd2;
        disk /dev/vg0/www;
        address 172.16.16.16:7794;
        meta-disk internal;
    }    
    on strong
    {        
        device /dev/drbd2;
        disk /dev/vg0/www;
        address 172.16.16.15:7794;
        meta-disk internal; 
    }

}


---


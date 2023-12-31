import React from 'react';
import clsx from 'clsx';
import styles from './HomepageFeatures.module.css';

const FeatureList = [
  {
    title: 'Reduce your development time',
    Svg: require('../../static/img/reduce-development-time.svg').default,
    description: (
      <>
        Bind your data to widgets quickly and easily, complete with validation.
      </>
    ),
  },
  {
    title: 'Focus on What Matters',
    Svg: require('../../static/img/focus.svg').default,
    description: (
      <>
        Generate your Back4App schema and server side validation automatically from the client schema - no mis-matches!
      </>
    ),
  },
  {
    title: 'Free to Flutter',
    Svg: require('../../static/img/free-to-flutter.svg').default,
    description: (
      <>
         Remain free to use all the power of Flutter as you wish.
      </>
    ),
  },
];

function Feature({Svg, title, description}) {
  return (
    <div className={clsx('col col--4')}>
      <div className="text--center">
        <Svg className={styles.featureSvg} alt={title} />
      </div>
      <div className="text--center padding-horiz--md">
        <h3>{title}</h3>
        <p>{description}</p>
      </div>
    </div>
  );
}

export default function HomepageFeatures() {
  return (
    <section className={styles.features}>
      <div className="container">
        <div className="row">
          {FeatureList.map((props, idx) => (
            <Feature key={idx} {...props} />
          ))}
        </div>
      </div>
    </section>
  );
}
